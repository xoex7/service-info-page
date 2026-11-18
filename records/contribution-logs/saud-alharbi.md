# Contribution Log – Saud Alharbi (`xoex7`)

Lead role: Linux & VM. Check every line before submitting; this log must be your own.

| Date | Task planned | Task completed | Evidence link | Problem met | Next action |
|---|---|---|---|---|---|
| 2026-11-15 | Set up repository and planning | Repo, team plan, risk register, task board with issues #1–#5 | commits `f2c2c94`, `3dbf76c` | – | Create VM |
| 2026-11-17 | Install lab VM (issue #1) | Ubuntu Server 26.04.1 LTS VM, NAT + host-only 192.168.56.10, SSH, updates, snapshot `01-clean-install` | `docs/environment.md` (PR: ____) | Hyper-V on host: soft-lockup warning and console keyboard froze; fixed with VM reset, worked over SSH | Accounts and permissions |
| 2026-11-17 | Accounts, permissions (issue #2) | Users `saud`, `abdulrhman`, `hamza`; group `devops`; `/opt/service-info` mode 2770; sudo for 2 members | `docs/linux-admin.md` (PR #10) | Found `saud` in `lxd` group (unneeded root-level access) | Firewall and Docker |
| 2026-11-18 | Docker and firewall check (Step 3B) | Connectivity check from the Windows host (22 allowed, 3306 blocked); Docker 29.1.3 installed, team accounts in `docker` group. Firewall rules were applied by Abdalrhman | `docs/linux-setup.md` | – | Deploy v1.0.0 (CR-001) |
| 2026-11-18 | Deploy v1.0.0 (CR-001) | Snapshot `02-before-v1.0.0`; pulled CI image, digest matches build-info; deployed with `deploy.sh`, health check HEALTHY, page shows 1.0.0 | CR-001, [issue #15](https://github.com/xoex7/service-info-page/issues/15) | – | Release v1.1.0 (CR-002) |
| | | | | | |
