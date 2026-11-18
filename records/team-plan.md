# Team Plan

## Members and roles
| Student | GitHub username | Initial lead role |
|---|---|---|
| A: Saud Alharbi | `xoex7` (repository owner) | Linux & VM |
| B: Abdalrhman Alsamiri | `oy-d7` | Application & Docker |
| C: Hamza Alhazmi | `7amzah90-tech` | CI & tests |

Reviews and deployment/recovery tasks rotate between all members.
Every member must: do some Linux administration, contribute to CI or tests,
take part in a deployment or recovery exercise, author at least 2 pull requests
and review at least 2 pull requests (tracked in `docs/git-workflow.md`).

## Scope
A Python (Flask) web page showing a fictional service name, support
contact, service hours and app version, plus a `/health` endpoint.
Packaged as a Docker image, tested and built by GitHub Actions,
deployed on one Ubuntu VM (`docs/environment.md`).

Out of scope: database, user login, paid cloud, Kubernetes, public hosting.

## Fictional service details (synthetic data only)
- Name: Campus Print Service
- Contact: print-support@example.com
- Hours: Sunday to Thursday, 08:00 - 16:00

## Milestones
| Week | Goal | Status |
|---|---|---|
| 1 | Plan, VM, repo, Linux administration | In progress |
| 2 | App, tests, Dockerfile, reviewed PRs | Done (PR #7) |
| 3 | CI pipeline, failed + passed runs, saved image | Pipeline done; failed run still needed |
| 4 | Two releases, failure recovery, rollback | v1.0.0 tagged; deploy, v1.1.0, failure, rollback to do |
| 5 | Improvement, documentation, demo | Not started |

## Working rules
- Task board: GitHub Projects board linked to this repository; one issue per task.
- Every change goes through a pull request with one approving review from another member.
- Weekly update to the instructor every week (`records/weekly-updates/`).
- Each member keeps their own contribution log (`records/contribution-logs/`).
