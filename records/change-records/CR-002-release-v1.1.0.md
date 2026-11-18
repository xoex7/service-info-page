# Change Record CR-002: Release v1.1.0 (location and status)

| Field | Value |
|---|---|
| Title | Show service location and status on the page (v1.1.0) |
| Author (proposes) | ________ |
| Reviewer / approver | ________ (must be a different member) |
| Date requested | ________ |
| Related PR(s) | #8 (location and status), #9 (deploy health check uses BIND_ADDR) |

## Proposed change
Upgrade the service from v1.0.0 to v1.1.0. The page gains two fields:
location ("Main Library, Ground Floor") and service status ("Operational").
`deploy.sh` now checks health on the address the port is published on.

## Impact
A short interruption (a few seconds) while the old container is replaced.
No configuration or firewall change.

## Testing done
- PR #8 CI run: passed. PR #9 CI run: passed.
- CI run for tag `v1.1.0`: ________ (link), flake8 + ___ tests passed.

## Artifact
| Item | Value |
|---|---|
| Release version | 1.1.0 (git tag `v1.1.0`) |
| Git commit | `________` |
| CI run | #___, ________ (link) |
| Image | `ghcr.io/xoex7/service-info-page:1.1.0` |
| Image ID (from `build-info.txt`) | `sha256:________` |

## Deployment plan
Take a VM snapshot first (name: `02-before-v1.1.0`), then:
```bash
cd ~/service-info-page && git pull
BIND_ADDR=192.168.56.10 ./scripts/deploy.sh 1.1.0
```

## Recovery plan
```bash
BIND_ADDR=192.168.56.10 ./scripts/rollback.sh 1.0.0
./scripts/healthcheck.sh http://192.168.56.10:8080/health
```
Confirm the page and `/health` show version 1.0.0. Record the rollback time.

## Approval
Approved by ________ on ________ (PR review or comment link: ________)

## Result
| Item | Value |
|---|---|
| Deployed by / at | ________ |
| Health check output | ________ |
| Version shown on page | ________ |
| Notes | ________ |
