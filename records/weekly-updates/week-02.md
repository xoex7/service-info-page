# Weekly Update – Week 2 (15–20 November 2026)

**To:** Instructor (stakeholder) **From:** Saud Alharbi, Abdalrhman Alsamiri, Hamza Alhazmi
**Status:** written, not sent to the instructor

**Repository:** https://github.com/xoex7/service-info-page
**Current release:** v1.1.0 running on `dev-opsvm` (192.168.56.10)

## Completed
- Lab environment: VM `dev-opsvm` (Ubuntu Server 26.04.1 LTS) with named accounts for all
  three members, a shared `devops` group, a `ufw` firewall allowing only SSH and the app from
  the lab network, Docker, and recovery snapshots.
- CI pipeline: lint, 5 automated tests and a smoke test; a failing check blocks the image build
  (PR #12: failed run, then fixed run). Versioned images in GHCR, traceable to commit and CI run.
- Two approved releases: v1.0.0 (CR-001, deployed by Saud) and v1.1.0 (CR-002, deployed by
  Hamza). The image ID on the VM matched the CI build both times.
- Recovery: controlled failure INC-001 (outage 2 min 46 s, detected in 25 s) and timed rollback
  RB-001 (v1.1.0 → v1.0.0 in 2 s).
- Improvement: shared deployment history, so any member can roll back after someone else
  deployed (before/after in `docs/improvement.md`, PRs #23 and #24).
- Collaboration: every member has authored and reviewed pull requests; `main` is protected
  (pull request with one approval).

## Next
- Final report, README walkthrough by a teammate, individual reflections, demo rehearsal.

## Risks
| Risk | Mitigation |
|---|---|
| The host laptop runs Windows virtualization-based security (Hyper-V) and has little free RAM, so the VM freezes at times (kernel soft lockups of up to several minutes). | Disable VBS on the host and close other applications before the demo; use SSH and VM snapshots as fallbacks. |
| The v1.1.0 deployment happened before its VM snapshot was taken. | Recorded as a deviation in CR-002; the deployment checklist now has a snapshot stop point. |

## Decisions needed
- None.

## Note
Neither weekly update was sent to the instructor during the project. Both are kept here as
written so the record is honest; this is listed as a lesson in the report.
