# Steps 7 & 8 – CI pipeline and the failed-then-fixed run

## What the pipeline does (`.github/workflows/ci.yml`)

Runs on: every pull request, every push to `main`, every tag like `v1.0.0`.

| Job | Steps | If it fails |
|---|---|---|
| **Lint and test** | install deps → `flake8` (static check) → `pytest` (4 tests) → upload `test-results.xml` | pipeline is red, **build job does not run**, no image is made |
| **Build versioned Docker image** (`needs: test`) | build image with version + commit SHA labels → smoke test `/health` → `docker save` → upload `docker-image-<version>` artifact (kept 90 days) with `build-info.txt` → on push/tag also push to GHCR | no artifact |

`build-info.txt` links together: release version, git commit, pipeline run URL,
image tag and image ID. This is the traceability record.

Tests:
1. `test_index_shows_service_information` – normal output
2. `test_health_returns_ok` – `/health`
3. `test_unknown_page_returns_404` – error case
4. `test_version_comes_from_environment` – edge case (version set at deploy time)

Security: the workflow token has `contents: read` only; the build job adds
`packages: write` to push to GHCR. No other secrets are used.

## Step 8 – Show a failed run, then the fix

1. Create a branch:
   ```bash
   git checkout main && git pull
   git checkout -b demo/failing-ci
   ```
2. Break something on purpose. In `app.py` change the health response to:
   ```python
   return jsonify(status="down", version=VERSION), 200
   ```
   and add an unused import at the top: `import sys`
3. Commit, push, open a PR titled **"Demo: change health status (expected to fail CI)"**.
4. CI result: **red**. `flake8` reports `F401 'sys' imported but unused`.
   (If you remove the import, `pytest` fails `test_health_returns_ok`.)
   The build job shows **skipped** → no image was created. Screenshot / copy the run link.
5. Reviewer writes a "Request changes" review pointing to the failing check.
6. Author fixes: put back `status="ok"` and remove `import sys`. Commit
   `"Fix health status and remove unused import"`, push to the same branch.
7. CI runs again: **green**, build job creates the image artifact. Copy that run link.
8. Reviewer approves → merge.
9. Record both run links in `docs/evidence-index.md`.
