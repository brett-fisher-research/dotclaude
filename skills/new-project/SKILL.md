---
name: new-project
description: Create and initialize a new project directory in your configured projects location. Resolves the location from ~/.claude/workspace.conf, prompting once and saving it if unset (default ~/Desktop/projects on Windows, ~/projects on Mac/Linux). Use when the user says "/new-project", "start a new project", "scaffold a new project", or "create a project called X".
argument-hint: "<project-name>"
allowed-tools: Bash Read Write Edit AskUserQuestion
---

# Create a new project

One job: make a new project directory under the configured projects location and initialize it.

Project name is in `$ARGUMENTS`; if bare, ask for it (kebab-case).

## Steps

1. **Resolve the projects directory.** Read it from the machine-local config:
   ```bash
   CONFIG=~/.claude/workspace.conf
   PROJECTS_DIR=$(grep -E '^projects_dir=' "$CONFIG" 2>/dev/null | head -1 | cut -d= -f2-)
   ```
   - **Set** → use `$PROJECTS_DIR`.
   - **Unset/empty** → STOP and prompt the user with `AskUserQuestion` for their projects dir. Offer the OS default as the recommended answer:
     - Windows (`uname` contains `MINGW`/`MSYS`/`CYGWIN`, or `$OS` = `Windows_NT`) → `~/Desktop/projects`
     - else (Mac/Linux) → `~/projects`

     Then **persist** their choice so it's never asked again:
     ```bash
     mkdir -p "$(dirname "$CONFIG")"
     echo "projects_dir=<chosen-path>" >> "$CONFIG"
     ```
     `workspace.conf` lives under `~/.claude`, which the repo's `.gitignore` ignores by default — so it stays machine-local and is never committed.

2. **Create + initialize the project.** Refuse to clobber an existing dir:
   ```bash
   DEST="$PROJECTS_DIR/<project-name>"
   [ -e "$DEST" ] && { echo "exists: $DEST"; exit 1; }
   mkdir -p "$DEST"
   git -C "$DEST" init -b main
   printf '# %s\n' "<project-name>" > "$DEST/README.md"
   ```

3. **Report.** Print the created path (`$DEST`) and that it's a fresh git repo on `main` with a seeded `README.md`. Suggest the user `cd` there to start working.

## Composition

- Standalone entry point — does not run inside `/pr` (it creates a *new* repo, not a change to this one).
- Once inside the new project, code changes there follow the usual `/pr` → `/raise` → `/merge` flow.
- Reuses the machine-local-config pattern: anything else that varies per machine can add keys to `~/.claude/workspace.conf`.
