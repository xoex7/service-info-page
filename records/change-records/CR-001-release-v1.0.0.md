# Change Record CR-001: Initial release v1.0.0

| Field | Value |
|---|---|
| Title | First deployment of the Campus Print Service page (v1.0.0) |
| Author (proposes) | Saud Alharbi |
| Reviewer / approver | Abdalrhman Alsamiri |
| Date requested | 2026-11-18 ([issue #15](https://github.com/xoex7/service-info-page/issues/15)) |
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
- CI run link: https://github.com/xoex7/service-info-page/actions/runs/43950973255

## Artifact
| Item | Value |
|---|---|
| Release version | 1.0.0 (git tag `v1.0.0`) |
| Git commit | `7699c84dbb0f0ae2ff58e9121433cccdbfe724e5` |
| CI run | [#3](https://github.com/xoex7/service-info-page/actions/runs/43950973255) |
| Image | `ghcr.io/xoex7/service-info-page:1.0.0` (also `:7699c84`) |
| Image ID (from `build-info.txt`) | `sha256:783bd215eb1e938e769557128203661f14ab18364350d9714ddeea9731ce9dea` |

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
Approved by Abdalrhman Alsamiri on 2026-11-18 20:33 UTC, before deployment
([issue #15 comment](https://github.com/xoex7/service-info-page/issues/15)):
"Checked CR-001: artifact, plan and recovery look correct. Approved."

## Result
| Item | Value |
|---|---|
| Snapshot before change | `02-before-v1.0.0` (2026-11-18, ~20:37 UTC) |
| Deployed by / at | Saud Alharbi (`saud`), 2026-11-18T20:39:25Z |
| Registry digest on VM | `ghcr.io/xoex7/service-info-page@sha256:783bd215eb1e938e769557128203661f14ab18364350d9714ddeea9731ce9dea` |
| Deployed image ID | `sha256:783bd215eb1e938e769557128203661f14ab18364350d9714ddeea9731ce9dea`, **matches** `image_id` in `build-info.txt` of CI run #3 |
| Health check output | `HEALTHY http://192.168.56.10:8080/health -> {"status":"ok","version":"1.0.0"}` |
| Version shown on page | 1.0.0 (checked in a browser on the Windows host at http://192.168.56.10:8080) |
| Notes | Deployed with the fixed `deploy.sh` from PR #9 (default `BIND_ADDR=192.168.56.10`). Change successful, no recovery needed. |

### Deployment output
```
saud@dev-opsvm:~/service-info-page$ docker pull ghcr.io/xoex7/service-info-page:1.0.0
...
Digest: sha256:783bd215eb1e938e769557128203661f14ab18364350d9714ddeea9731ce9dea
Status: Downloaded newer image for ghcr.io/xoex7/service-info-page:1.0.0
saud@dev-opsvm:~/service-info-page$ docker image inspect --format '{{index .RepoDigests 0}}' ghcr.io/xoex7/service-info-page:1.0.0
ghcr.io/xoex7/service-info-page@sha256:783bd215eb1e938e769557128203661f14ab18364350d9714ddeea9731ce9dea
saud@dev-opsvm:~/service-info-page$ bash scripts/deploy.sh 1.0.0
2026-11-18T20:39:25+00:00 Deploying ghcr.io/xoex7/service-info-page:1.0.0
d0e5850a0c7389611bcf8b631422084293b85156a931678ae75831cb73f439ac
2026-11-18T20:39:29+00:00 HEALTHY http://192.168.56.10:8080/health -> {"status":"ok","version":"1.0.0"}
Deployed image ID: sha256:783bd215eb1e938e769557128203661f14ab18364350d9714ddeea9731ce9dea
```
