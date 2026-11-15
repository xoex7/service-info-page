# Team Plan

## Members and roles
| Student | GitHub username | Initial lead role |
|---|---|---|
| A: Saud Alharbi | <user> | Linux & VM |
| B: Abdalrhman Alsamiri | <user> | Application & Docker |
| C: Hamza Alhazmi | <user> | CI & tests |

Reviews and deployment/recovery tasks rotate between all members.

## Scope
A Python (Flask) web page showing a fictional service name, support
contact, service hours and app version, plus a /health endpoint.
Packaged as a Docker image, tested and built by GitHub Actions,
deployed on one Ubuntu VM.

## Fictional service details
- Name: Campus Print Service
- Contact: print-support@example.edu
- Hours: Sun–Thu 08:00–16:00

## Milestones
| Week | Goal |
|---|---|
| 1 | Plan, VM, repo |
| 2 | App, tests, Dockerfile, reviewed PRs |
| 3 | CI pipeline, failed + passed runs, saved image |
| 4 | Two releases, failure recovery, rollback |
| 5 | Improvement, documentation, demo |
