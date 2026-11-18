# Change Record CR-002: Release v1.1.0 (location and status)

| Field | Value |
|---|---|
| Title | Show service location and status on the page (v1.1.0) |
| Author (proposes) | Abdalrhman Alsamiri (deployer) |
| Reviewer / approver | Hamza Alhazmi |
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
Approved by ________ on ________ (PR review or comment link: ________)

## Result
| Item | Value |
|---|---|
| Deployed by / at | Abdalrhman Alsamiri, ________ |
| Health check output | ________ |
| Version shown on page | ________ |
| Notes | ________ |
