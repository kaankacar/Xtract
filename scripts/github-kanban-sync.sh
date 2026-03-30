#!/usr/bin/env bash
# github-kanban-sync.sh
# Polls XTract-build/Xtract for new GitHub issues and PRs,
# creates a Kanban task for each one not yet synced.
# Designed to run every 30 minutes via launchd.

set -euo pipefail

REPO="XTract-build/Xtract"
PROJECT_PATH="/Users/kaan/Desktop/XTract"
SYNC_FILE="$PROJECT_PATH/.kanban-github-sync.json"
KANBAN_NODE="/opt/homebrew/Cellar/node/25.6.1/bin/node"
KANBAN_BIN="/opt/homebrew/bin/kanban"
LOG="$PROJECT_PATH/.kanban-github-sync.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

# Ensure sync state file exists
if [ ! -f "$SYNC_FILE" ]; then
  echo '{"issues":[],"prs":[]}' > "$SYNC_FILE"
  log "Created new sync state file"
fi

log "Checking $REPO for new issues and PRs..."

# Fetch open issues and PRs as JSON
ISSUES_JSON=$(gh issue list --repo "$REPO" --state open --json number,title,body,labels --limit 100)
PRS_JSON=$(gh pr list --repo "$REPO" --state open --json number,title,body,labels --limit 50)

# Run the sync logic in Python (has access to all data)
python3 << PYEOF
import json, subprocess, sys
from datetime import datetime

sync_file  = "$SYNC_FILE"
project    = "$PROJECT_PATH"
kanban     = ["$KANBAN_NODE", "$KANBAN_BIN"]
log_file   = "$LOG"

def log(msg):
    line = f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {msg}"
    print(line)
    with open(log_file, 'a') as f:
        f.write(line + "\n")

def create_task(prompt):
    result = subprocess.run(
        kanban + ["task", "create", "--project-path", project, "--prompt", prompt],
        capture_output=True, text=True
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip())
    return json.loads(result.stdout)["task"]["id"]

state = json.load(open(sync_file))
synced_issues = set(state.get("issues", []))
synced_prs    = set(state.get("prs", []))

issues = $ISSUES_JSON
prs    = $PRS_JSON

new_issues = 0
new_prs    = 0

# ── Issues ──────────────────────────────────────────────────────────────────
for issue in issues:
    n = issue["number"]
    if n in synced_issues:
        continue
    title  = issue["title"]
    body   = (issue.get("body") or "").strip()
    labels = ", ".join(l["name"] for l in issue.get("labels", []))
    label_str = f"\nLabels: {labels}" if labels else ""
    prompt = (
        f"GitHub Issue #{n}: {title}{label_str}\n\n"
        f"URL: https://github.com/XTract-build/Xtract/issues/{n}\n\n"
        + (body if body else "(no description)")
    )
    try:
        task_id = create_task(prompt)
        state["issues"].append(n)
        synced_issues.add(n)
        new_issues += 1
        log(f"Issue #{n} → Kanban task {task_id}: {title}")
    except Exception as e:
        log(f"ERROR: Issue #{n} failed: {e}")

# ── Pull Requests ────────────────────────────────────────────────────────────
for pr in prs:
    n = pr["number"]
    if n in synced_prs:
        continue
    title  = pr["title"]
    body   = (pr.get("body") or "").strip()
    labels = ", ".join(l["name"] for l in pr.get("labels", []))
    label_str = f"\nLabels: {labels}" if labels else ""
    prompt = (
        f"GitHub PR #{n}: {title}{label_str}\n\n"
        f"URL: https://github.com/XTract-build/Xtract/pull/{n}\n\n"
        f"Review this pull request against the v1.0 plan. Check that changes are "
        f"correct, tests are included, and there are no regressions. "
        f"Summarize what the PR does and whether it is ready to merge.\n\n"
        + (body if body else "(no description)")
    )
    try:
        task_id = create_task(prompt)
        state["prs"].append(n)
        synced_prs.add(n)
        new_prs += 1
        log(f"PR #{n} → Kanban task {task_id}: {title}")
    except Exception as e:
        log(f"ERROR: PR #{n} failed: {e}")

# Save updated state
json.dump(state, open(sync_file, "w"), indent=2)
log(f"Sync complete — {new_issues} new issue task(s), {new_prs} new PR task(s)")
PYEOF
