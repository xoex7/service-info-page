# Change Record CR-001: Initial release v1.0.0

| Field | Value |
|---|---|
| Title | First deployment of the Campus Print Service page (v1.0.0) |
| Author (proposes) | ________ |
| Reviewer / approver | ________ (must be a different member) |
| Date requested | ________ |
| Related PR(s) | #7 (app, tests, CI, Dockerfile, scripts) |

## Proposed change
Deploy release v1.0.0 to the lab VM `dev-opsvm` (192.168.56.10). This is the
first release: it shows the service name, support contact, service hours and
version, and answers `/health`.

## Impact
New service; nothing is running yet, so no downtime for users.
Port 8080 is published only on the host-only address 192.168.56.10
(allowed by the `ufw` rule for 192.168.56.0/24).

## Testing done
- CI run #3 for tag `v1.0.0`: flake8 passed, 4 pytest tests passed, smoke test of `/health` passed.
- CI run link: ________

## Artifact
| Item | Value |
|---|---|
| Release version | 1.0.0 (git tag `v1.0.0`) |
| Git commit | `7699c84dbb0f0ae2ff58e9121433cccdbfe724e5` |
| CI run | #3, ________ (link) |
| Image | `ghcr.io/xoex7/service-info-page:1.0.0` (also `:7699c84`) |
| Image ID (from `build-info.txt`) | `sha256:________` |

## Deployment plan
Follow `docs/deployment-checklist.md`:
```bash
cd ~/service-info-page && git pull
BIND_ADDR=192.168.56.10 ./scripts/deploy.sh 1.0.0
docker image inspect --format '{{.Id}}' ghcr.io/xoex7/service-info-page:1.0.0
```
The image ID on the VM must match the image ID in `build-info.txt`.

## Recovery plan
First release, so there is no earlier version to roll back to. If the health
check fails: `docker logs service-info`, stop the container
(`docker rm -f service-info`), fix through a new PR, and restore the VM
snapshot `01-clean-install` if the VM itself is damaged.

## Approval
Approved by ________ on ________ (PR review or comment link: ________)

## Result
| Item | Value |
|---|---|
| Deployed by / at | ________ |
| Health check output | ________ |
| Version shown on page | ________ |
| Notes | ________ |
