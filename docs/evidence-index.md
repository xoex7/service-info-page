# Evidence Index

Links to the evidence for each requirement. Fill in the blanks as the work happens.
Base URL: https://github.com/xoex7/service-info-page

## Planning and Linux (rubric: plan 8, Linux 10)
| Requirement | Evidence | Owner |
|---|---|---|
| Team plan, roles, milestones | `records/team-plan.md` | Saud |
| Task board | GitHub Projects board (link: ________) | All |
| Risk register | `records/risk-register.md` | All |
| Weekly updates | `records/weekly-updates/` | All |
| VM configuration + snapshot | `docs/environment.md` (PR: ____) | Saud |
| Named accounts, permissions, process/service/disk checks | `docs/linux-admin.md` (PR #10) | Saud |
| Firewall rules + connectivity check | `docs/linux-setup.md` | Abdalrhman (firewall), Saud (host check) |
| Docker installed | `docs/linux-setup.md` | Saud |

## Git and review (rubric: 8)
| Requirement | Evidence | Owner |
|---|---|---|
| App page (closed, replaced by #7) | [PR #6](https://github.com/xoex7/service-info-page/pull/6) | Abdalrhman |
| App, tests, Dockerfile, CI, scripts | [PR #7](https://github.com/xoex7/service-info-page/pull/7) (merged, approved) | Hamza |
| Location + status (v1.1.0 change) | [PR #8](https://github.com/xoex7/service-info-page/pull/8) | Abdalrhman |
| deploy.sh health check fix | [PR #9](https://github.com/xoex7/service-info-page/pull/9) | Abdalrhman |
| Linux admin docs | [PR #10](https://github.com/xoex7/service-info-page/pull/10) (reviewed by Abdalrhman, approved by Hamza) | Saud |
| Records and cleanup | [PR #11](https://github.com/xoex7/service-info-page/pull/11) (approved by Hamza) | Saud |
| CI failure demo (fail → fix → pass) | [PR #12](https://github.com/xoex7/service-info-page/pull/12) | Hamza |
| Test for location/status (improvement) | [PR #13](https://github.com/xoex7/service-info-page/pull/13) | Hamza |
| PR / review count per member | `docs/git-workflow.md` (tracker table) | All |

## CI and artifacts (rubric: 16)
| Requirement | Evidence | Owner |
|---|---|---|
| Pipeline definition | `.github/workflows/ci.yml` | Hamza |
| Failed CI run (lint or test fails, build skipped) | [CI run #12](https://github.com/xoex7/service-info-page/actions/runs/44322907383): `test_health_returns_ok` failed, build job skipped (PR #12, commit `705490b`) | Hamza |
| Corrected green run | [CI run #13](https://github.com/xoex7/service-info-page/actions/runs/44326848816): lint, tests and image build passed (commit `224181f`) | Hamza |
| Test results artifact | `test-results-<sha>` on the run page | Hamza |
| Image artifact + `build-info.txt` for v1.0.0 | [CI run #3](https://github.com/xoex7/service-info-page/actions/runs/43950973255) (tag `v1.0.0`), artifact `docker-image-1.0.0`, image ID `sha256:783bd215…` | Hamza |
| GHCR image v1.0.0 | `ghcr.io/xoex7/service-info-page:1.0.0` | Hamza |
| Image artifact + GHCR image for v1.1.0 | [CI run #31](https://github.com/xoex7/service-info-page/actions/runs/44402045414), image ID `sha256:fa8dc360…` | Saud (release) |

## Release, deployment and recovery (rubric: 12)
| Requirement | Evidence | Owner |
|---|---|---|
| Release mapping v1.0.0 (version, commit, run, image ID) | `records/change-records/CR-001-release-v1.0.0.md`, approval [#15](https://github.com/xoex7/service-info-page/issues/15) | Saud (deploy), Abdalrhman (approve) |
| Release mapping v1.1.0 | `records/change-records/CR-002-release-v1.1.0.md`, approval [#19](https://github.com/xoex7/service-info-page/issues/19) | Hamza (deploy), Abdalrhman (approve) |
| Deployment checklist | `docs/deployment-checklist.md` | ________ |
| Deployment output + health check | CR-001 "Result" (v1.0.0); CR-002 "Result" (v1.1.0) | Saud (v1.0.0), Hamza (v1.1.0) |
| Container status, logs, health, disk, service status | `docs/observation.md` | Hamza |
| Controlled failure + incident update | `records/incidents/INC-001-controlled-failure.md` (outage 2 min 46 s, detected in 25 s) | Hamza |
| Rollback v1.1.0 → v1.0.0 with measured time | `records/incidents/RB-001-rollback-test.md` | ________ |

## Security, documentation and improvement (rubric: 8 + 8)
| Requirement | Evidence | Owner |
|---|---|---|
| Synthetic data only | `app.py` (`SERVICE_INFO`) | All |
| Secret handling (no secrets in Git; only `GITHUB_TOKEN`) | `.gitignore`, `ci.yml` `permissions:` | Hamza |
| Least privilege (accounts, CI token, non-root container) | `docs/linux-admin.md`, `ci.yml`, `Dockerfile` | All |
| Improvement (main): shared deployment history, before / after | `docs/improvement.md` (before = RB-001: rollback without a version failed for another member) | All |
| Improvement (additional): test for location/status | [PR #13](https://github.com/xoex7/service-info-page/pull/13): before, removing the location line still passed CI (4 tests); after, the new test fails (`1 failed, 4 passed`) | Hamza |
| README followed by a teammate | ________ | ________ |
| References and AI disclosure | `records/references.md`, `records/ai-assistance-disclosure.md` | All |
| Contribution logs | `records/contribution-logs/` | Each member |
