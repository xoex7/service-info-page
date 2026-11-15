# Step 4 – Git workflow on Windows (clone, branch, pull request, review)

## Rules

- `main` must always work. Nobody pushes directly to `main`.
- Every change: new branch → pull request (PR) → one teammate reviews → CI green → merge.
- Each student **authors at least 2 PRs** and **reviews at least 2 PRs**.
- A review must contain a real check, question or explanation (not just "LGTM").

## One-time setup (owner: Saud, repository owner)

1. Settings → Collaborators → add Hamza and Abdalrhman with **Write** access.
2. Settings → Branches → Add branch ruleset for `main`:
   - Require a pull request before merging, 1 approval
   - Require status checks to pass: `Lint and test`, `Build versioned Docker image`
   - Block force pushes

## One-time setup (every student, Windows)

Install Git for Windows (https://git-scm.com), then in Git Bash or PowerShell:

```bash
git config --global user.name "Your Name"
git config --global user.email "your-github-email"
git clone https://github.com/xoex7/service-info-page.git
cd service-info-page
```

The first `git push` opens a browser window to sign in to GitHub.

## Every change

```bash
git checkout main
git pull                               # get the latest main
git checkout -b feature/short-name     # new branch
# ... edit files ...
git add .
git commit -m "Add /health endpoint tests"
git push -u origin feature/short-name
```

On GitHub: **Compare & pull request** → write what changed, why, and how it was
tested → choose a teammate as **Reviewer** → Create.

## Reviewing (on GitHub)

1. Open the PR → **Files changed**.
2. Click a line → add a comment (question, risk, or suggestion).
3. **Review changes** → *Approve* or *Request changes*.
4. Merge only after approval and green CI. Delete the branch after merging.

Good review comment examples:
- "The container still runs as root here – can we add `USER appuser`?"
- "What happens if `APP_VERSION` is not set? Please add a test."
- "I ran `pytest` locally on this branch: 4 passed."

## Planned pull requests

| # | Branch | Author | Reviewer | Content |
|---|---|---|---|---|
| 1 | `feature/app` (PR #6) | Abdalrhman | Saud | `app.py` |
| 2 | `feature/tests` | Hamza | Saud | `tests/` |
| 3 | `feature/dockerfile` | Abdalrhman | Saud | `Dockerfile`, `.dockerignore` |
| 4 | `feature/ci-pipeline` | Hamza | Abdalrhman | `.github/workflows/ci.yml` |
| 5 | `feature/deploy-scripts` | Saud | Hamza | `scripts/`, `docs/deployment-checklist.md` |
| 6 | `docs/readme` | Saud | Abdalrhman | `README.md`, `docs/`, `records/` |
| 7 | `demo/failing-ci` | Hamza | Saud | Deliberate failure for Step 8 (see `ci-guide.md`) |
