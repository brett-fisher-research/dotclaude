---
name: raise
description: Push the current PR branch and open the pull request. Use when the user says "/raise", "raise the PR", "open the PR", "put up the PR". This is step 2 of the PR workflow (after /pr sets up the branch and the work is committed); the user reviews the opened PR and suggests follow-ups, then invokes /merge when happy. Opens against the base /pr used (main by default; pass --base for an integration branch), and updates the Linear ticket when the branch is named <ID>/slug.
argument-hint: "[--base <branch>] [PR title / extra context]"
allowed-tools: Bash Read mcp__claude_ai_Linear__save_comment mcp__claude_ai_Linear__save_issue
---

# Raise the pull request

Step 2 of the PR workflow (`/pr` → **`/raise`** → `/merge`). The branch already exists with its
commits; this skill pushes it and opens the PR against the **same base `/pr` branched from**. After
it's up, the user reviews and may ask for follow-ups (more commits on the same branch — keep
committing per `/pr`), then runs **`/merge`** when satisfied.

## Steps

1. **Resolve the base + sanity-check.** Base = `--base <branch>` from `$ARGUMENTS`, else `main`. We
   must be on a PR branch, clean, with commits ahead of the base:
   ```bash
   git branch --show-current            # must NOT be the base
   git status --porcelain               # must be empty — commit anything outstanding first
   git log --oneline "origin/<base>..HEAD"
   ```
   - If on the base branch, stop — nothing to raise; the user likely needs `/pr` first.
   - If the tree is dirty, commit the remaining work (per `/pr`) before pushing.
   - If there are no commits ahead of the base, stop and tell the user.

2. **Push the branch** to the remote (HTTPS — auth via the gh credential helper; never SSH), setting
   upstream:
   ```bash
   git push -u origin "$(git branch --show-current)"
   ```

3. **Open the PR** against the resolved base. Write a real title and body — summarize what changed and
   why, derived from the commits/diff. `$ARGUMENTS` may supply a title or extra context:
   ```bash
   gh pr create --base <base> --head "$(git branch --show-current)" \
     --title "<concise title>" \
     --body "$(cat <<'EOF'
   ## Summary
   - <what changed and why>

   ## Test plan
   - <how it was verified>

   🤖 Generated with [Claude Code](https://claude.com/claude-code)
   EOF
   )"
   ```

4. **Update Linear (best-effort).** If the branch name starts with a ticket id — `^[A-Z]+-[0-9]+`,
   e.g. `FIS-123/dark-mode` — update that ticket via the Linear MCP:
   - add a **comment** with the PR URL, and
   - set its status to **In Review**.

   If the branch has no `<ID>` prefix (e.g. `feat/…`), skip this step entirely — no Linear touch.

5. **Report the PR URL** (`gh pr view --web` optional). Remind the user: review it, request any
   follow-ups (added as further commits on this branch), and invoke **`/merge`** when happy — passing
   `--base <branch>` if this PR targets a non-`main` base.
