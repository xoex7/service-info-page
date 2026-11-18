# Change Record CR-002: Release v1.1.0 (location and status)

| Field | Value |
|---|---|
| Title | Show service location and status on the page (v1.1.0) |
| Author (proposes) | Hamza Alhazmi (deployer) |
| Reviewer / approver | Abdalrhman Alsamiri |
| Date requested | 2026-11-19 (approval [issue #19](https://github.com/xoex7/service-info-page/issues/19)) |
| Related PR(s) | #8 (location and status), #9 (deploy health check uses BIND_ADDR, refuses 0.0.0.0), #13 (test for the new fields) |

## Proposed change
Upgrade the service from v1.0.0 to v1.1.0. The page gains two fields:
location ("Main Library, Ground Floor") and service status ("Operational").
`deploy.sh` now checks health on the address the port is published on.

## Impact
A short interruption (a few seconds) while the old container is replaced.
No configuration or firewall change.

## Testing done
- PR #8 CI run: passed. PR #9 CI run: passed.
- CI run for tag `v1.1.0`: [#31](https://github.com/xoex7/service-info-page/actions/runs/44402045414), flake8 + 5 tests passed, smoke test of `/health` passed.

## Artifact
| Item | Value |
|---|---|
| Release version | 1.1.0 (git tag `v1.1.0`) |
| Git commit | `cdcd9d483c11131755f0e8c0f41d6fc29f1b59c6` |
| CI run | [#31](https://github.com/xoex7/service-info-page/actions/runs/44402045414) |
| Image | `ghcr.io/xoex7/service-info-page:1.1.0` |
| Image ID (from `build-info.txt`) | `sha256:fa8dc360d10f868e90d39f9f2c2d7a11e27bfa6cfc6379f0980fd83bccea0de8` |

## Deployment plan
Take a VM snapshot first (name: `03-before-v1.1.0`), then:
```bash
cd ~/service-info-page && git pull
docker pull ghcr.io/xoex7/service-info-page:1.1.0
docker image inspect --format '{{index .RepoDigests 0}}' ghcr.io/xoex7/service-info-page:1.1.0
bash scripts/deploy.sh 1.1.0          # BIND_ADDR defaults to 192.168.56.10
```

## Recovery plan
```bash
bash scripts/rollback.sh 1.0.0
bash scripts/healthcheck.sh http://192.168.56.10:8080/health
```
Confirm the page and `/health` show version 1.0.0. Record the rollback time.

## Approval
Approved by Abdalrhman Alsamiri on 2026-11-18 21:33:55 UTC, before deployment
([issue #19 comment](https://github.com/xoex7/service-info-page/issues/19)):
"Checked CR-002: CI run #31 passed with 5 tests, image ID sha256:fa8dc360… matches build-info, and the rollback plan to 1.0.0 is clear. Approved."

## Result
| Item | Value |
|---|---|
| Deployed by / at | Hamza Alhazmi (own account `hamza`, member of `docker`, not `sudo`), 2026-11-18T21:36:28Z |
| Registry digest on VM | `ghcr.io/xoex7/service-info-page@sha256:fa8dc360d10f868e90d39f9f2c2d7a11e27bfa6cfc6379f0980fd83bccea0de8` |
| Deployed image ID | `sha256:fa8dc360d10f868e90d39f9f2c2d7a11e27bfa6cfc6379f0980fd83bccea0de8`, **matches** `image_id` in build-info of CI run #31 |
| Health check output | `HEALTHY http://192.168.56.10:8080/health -> {"status":"ok","version":"1.1.0"}` (4 s after start) |
| Version shown on page | 1.1.0, with Location and Service status (browser check: ________) |
| Snapshot | ⚠️ `03-after-v1.1.0`, taken ~21:37 UTC, **after** the deployment (see deviation) |
| Outcome | Change successful, no recovery needed |

### Deviation: snapshot taken after the change
The plan said to take snapshot `03-before-v1.1.0` first. The deployment started at
21:36:28 UTC, about one minute before the snapshot was taken, so the snapshot contains
v1.1.0 and was renamed to `03-after-v1.1.0` in VirtualBox.

- **Impact:** low. Approval came first (21:33:55), the previous image `1.0.0` was still on
  the VM so `rollback.sh 1.0.0` remained available, and `02-before-v1.0.0` is still a
  full VM restore point.
- **Cause:** the snapshot depended on someone remembering it; the deployer and the
  person taking the snapshot were different people and nothing made the deployer wait.
- **Action:** the deployment checklist now makes the snapshot a required step that the
  deployer confirms by name before running `deploy.sh` (`docs/deployment-checklist.md`).

### Deployment output
```
hamza@dev-opsvm:~/service-info-page$ docker pull ghcr.io/xoex7/service-info-page:1.1.0
...
Digest: sha256:fa8dc360d10f868e90d39f9f2c2d7a11e27bfa6cfc6379f0980fd83bccea0de8
Status: Downloaded newer image for ghcr.io/xoex7/service-info-page:1.1.0
hamza@dev-opsvm:~/service-info-page$ docker image inspect --format '{{index .RepoDigests 0}}' ghcr.io/xoex7/service-info-page:1.1.0
ghcr.io/xoex7/service-info-page@sha256:fa8dc360d10f868e90d39f9f2c2d7a11e27bfa6cfc6379f0980fd83bccea0de8
hamza@dev-opsvm:~/service-info-page$ bash scripts/deploy.sh 1.1.0
2026-11-18T21:36:28+00:00 Deploying ghcr.io/xoex7/service-info-page:1.1.0
ae72d3126ab09d436c3949129e97156ae7b2108e705ef150320a842f8a0d8f66
2026-11-18T21:36:32+00:00 HEALTHY http://192.168.56.10:8080/health -> {"status":"ok","version":"1.1.0"}
Deployed image ID: sha256:fa8dc360d10f868e90d39f9f2c2d7a11e27bfa6cfc6379f0980fd83bccea0de8
```
