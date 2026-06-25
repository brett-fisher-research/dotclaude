---
name: email-health
description: Check and troubleshoot email DNS health for a domain — SPF, DKIM, DMARC, MX records, and cross-domain DMARC reporting (rua) authorization. Use when the user asks about email deliverability, DNS records for email, DMARC/SPF/DKIM setup, or wants to verify a domain can send email properly.
---

# Email DNS Health Check

You help the user verify and fix email DNS configuration for their domains.

## Step 1: Run the CLI

Run the `email-check` CLI tool to get the current status:

```bash
email-check <domain>
```

This checks MX, SPF, DKIM (common selectors), DMARC, DMARC policy enforcement, and cross-domain RUA authorization. It exits 0 if everything passes, 1 if any check fails.

## Step 2: Interpret and explain results

- **✅ Pass** — record is correctly configured
- **⚠️ Warn** — works but could be improved (e.g., DKIM using a custom selector not in the common list, or DMARC policy set to `none`)
- **❌ Fail** — missing or misconfigured, needs action

Explain each failure in plain language. Tell the user exactly what DNS record to add or change, including the full record name, type, and value.

## Step 3: Common fixes reference

### SPF
- Google Workspace: `v=spf1 include:_spf.google.com ~all`
- Microsoft 365: `v=spf1 include:spf.protection.outlook.com ~all`
- Multiple providers: combine includes in one record (never have two `v=spf1` records)
- Use `~all` (softfail) during testing, `-all` (hardfail) for production

### DKIM
- Google: selector is `google`, set up via Admin Console > Apps > Google Workspace > Gmail > Authenticate email
- Microsoft 365: selectors are `selector1` and `selector2`, enabled via Exchange admin
- Other providers: check their docs for the selector name and CNAME/TXT to add

### DMARC
- Start with: `v=DMARC1; p=none; rua=mailto:<reporting-address>`
- After monitoring, escalate to `p=quarantine`, then `p=reject`
- The `rua` address receives aggregate reports (XML) about who's sending as your domain

### Cross-domain RUA authorization
If the DMARC `rua` address is on a **different domain** than the one being checked, the receiving domain must publish a TXT record authorizing it:

```
<sending-domain>._report._dmarc.<rua-domain>  TXT  "v=DMARC1"
```

Example: if `brettfishermedia.com` has `rua=mailto:brett@fisherresearch.dev`, then `fisherresearch.dev` needs:

```
brettfishermedia.com._report._dmarc.fisherresearch.dev  TXT  "v=DMARC1"
```

## Step 4: Re-verify after changes

After the user updates their DNS, re-run `email-check <domain>` to confirm the fix. Note that DNS propagation can take a few minutes to hours.

## Updating the CLI

When the user wants to add new checks or modify the CLI behavior, follow TDD:

1. Read `~/services/email-check/CLAUDE.md` for architecture and conventions
2. Write or update a test in `tests/test_checks.py` first
3. Run `cd ~/services/email-check && uv run pytest` — confirm the new test **fails**
4. Implement the change
5. Run `uv run pytest` — confirm all tests **pass**
6. Update `~/services/email-check/CLAUDE.md` to reflect any architectural changes
