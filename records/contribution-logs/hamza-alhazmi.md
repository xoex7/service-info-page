# Contribution Log – Hamza Alhazmi (`7amzah90-tech`)

Lead role: CI & tests. Fill in your own entries; one row per task.

| Date | Task planned | Task completed | Evidence link | Problem met | Next action |
|---|---|---|---|---|---|
| 2026-11-18 | Deploy v1.1.0 (CR-002) | Deployed v1.1.0 from own account `hamza` (docker group, no sudo); digest matches CI run #31; HEALTHY | CR-002, [issue #19](https://github.com/xoex7/service-info-page/issues/19) | Deployed before the snapshot was taken (recorded as deviation) | Controlled failure (INC-001) |
| 2026-11-18 | Observation + controlled failure (INC-001) | Ran the operator checks (`docker ps`, logs, health, disk, docker service); stopped the container, detected UNHEALTHY in 25 s, recovered with `docker start` (7 s) | `docs/observation.md`, INC-001 | Unsure of next step after detection (2 min gap); found gunicorn worker timeouts in the logs | Send incident update; rollback test |
| 2026-11-19 | Part G after-test | Deployed 1.1.0 into the shared history from own account | `docs/improvement.md` | – | Report |
| | | | | | |
