# Contribution Log – Abdalrhman Alsamiri (`oy-d7`)

Lead role: Application & Docker. Fill in your own entries; one row per task.

| Date | Task planned | Task completed | Evidence link | Problem met | Next action |
|---|---|---|---|---|---|
| 2026-11-18 | Configure the VM firewall | ufw: default deny incoming / allow outgoing; allow 22 and 8080 from 192.168.56.0/24 only; enabled and checked with `ufw status verbose` | `docs/linux-setup.md` | | |
| 2026-11-19 | Rollback test (RB-001) | Rolled back v1.1.0 → v1.0.0 in 2 s from own account, verified version and image ID, rolled forward to v1.1.0 | `records/incidents/RB-001-rollback-test.md` | `rollback.sh` without a version failed (no deploy history for my account); VM froze before the test and needed a reset | Part G improvement |
| 2026-11-19 | Part G after-test | `rollback.sh` with no version rolled back to 1.0.0 and forward to 1.1.0 automatically; reviewed PR #23 | `docs/improvement.md` | VM froze during the test (Hyper-V) | Report |
| | | | | | |
