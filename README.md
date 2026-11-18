# Campus Print Service – Service Information Page

A small internal web page for a **fictional** service. It shows the service name,
support contact, service hours and application version. It also has a `/health`
endpoint so an automated check can confirm the service is running.

Team: Saud Alharbi, Abdalrhman Alsamiri, Hamza Alhazmi.
All data is synthetic.

## Repository layout

| Path | What it is |
|---|---|
| `app.py` | Flask application (`/` page and `/health`) |
| `tests/test_app.py` | Automated tests (pytest) |
| `requirements.txt` / `requirements-dev.txt` | Runtime / test dependencies |
| `Dockerfile`, `.dockerignore` | Container image recipe |
| `.github/workflows/ci.yml` | CI pipeline (lint → test → build → save image) |
| `scripts/` | `deploy.sh`, `rollback.sh`, `healthcheck.sh` |
| `docs/` | Deployment checklist, Git workflow, CI guide, release guide |
| `records/` | Team plan, risks, change records, incidents, weekly updates |

## Prerequisites

- Ubuntu 22.04/24.04 VM (or WSL Ubuntu) with `git`, `python3` (3.10+), `python3-venv`, `curl`
- Docker Engine (`docker` command works without `sudo` for your user – see `docs/linux-setup.md`)

## 1. Get the code

```bash
git clone https://github.com/xoex7/service-info-page.git
cd service-info-page
chmod +x scripts/*.sh   # make the helper scripts runnable
```

## 2. Run the tests and static check

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements-dev.txt
flake8 app.py tests
pytest -v
```

Expected output: flake8 prints nothing, and pytest ends with `5 passed`.

## 3. Run locally without Docker (development only)

```bash
python app.py
curl http://127.0.0.1:8080/health
```

Expected: `{"status":"ok","version":"1.0.0"}`

## 4. Build and run with Docker

```bash
docker build --build-arg APP_VERSION=1.0.0 -t service-info-page:local .
docker run -d --name service-info -p 127.0.0.1:8080:5000 service-info-page:local
```

- **Port mapping:** host `127.0.0.1:8080` → container `5000`. Only localhost can reach it.
  To let another lab machine reach it, use the VM private IP instead of `127.0.0.1`.
- **User:** the container runs as `appuser` (UID 10001), not root.
  Check: `docker exec service-info whoami` → `appuser`
- **Configuration (environment variable):** `APP_VERSION` (set by CI at build time).
  Service details are in `SERVICE_INFO` inside `app.py`.

## 5. Health check and logs

```bash
curl http://127.0.0.1:8080/health          # {"status":"ok","version":"1.0.0"}
./scripts/healthcheck.sh                    # HEALTHY ... or UNHEALTHY (exit 1)
docker ps                                   # STATUS shows "(healthy)"
docker logs --tail 20 service-info          # application and access logs
df -h /                                     # disk usage
systemctl status docker --no-pager          # Docker service status
```

## 6. Deploy a release that passed CI

Every image is built by CI and stored in GitHub Container Registry (GHCR) as
`ghcr.io/xoex7/service-info-page:<version>` and `:<short-commit-sha>`.
We deploy that exact image; we never rebuild on the server.

```bash
./scripts/deploy.sh 1.0.0
```

The script pulls the image, starts it, runs the health check, and saves the
current and previous versions in `~/.service-info/`.
Follow `docs/deployment-checklist.md` for every deployment.

Offline option: download the `docker-image-<version>` artifact from the CI run, then
`gunzip -c image-<sha>.tar.gz | docker load` and tag it (see `docs/release-guide.md`).

## 7. Rollback

```bash
./scripts/rollback.sh          # back to the previous version
./scripts/rollback.sh 1.0.0    # or a named version
```

The script prints how many seconds the rollback took. Confirm the version on the
page and in `/health`.

## Workflow

Plan → branch → pull request → teammate review → CI passes → versioned image →
approved deploy → health check → monitor → improve.
See `docs/git-workflow.md`.

## AI assistance disclosure

Parts of the code and documentation were drafted with help from an AI assistant
(Claude). Every team member reviewed, tested and can explain the submitted work.
