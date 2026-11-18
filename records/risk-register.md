# Risk Register

Likelihood and impact: Low / Medium / High. Review this table every week.

| ID | Risk | Likelihood | Impact | Mitigation | Owner | Status |
|---|---|---|---|---|---|---|
| R1 | VM breaks or laptop fails | Medium | High | Take VM snapshots before major changes (`01-clean-install` taken 2026-11-17); all code lives in GitHub | Saud Alharbi | Open |
| R2 | A teammate is unavailable | Medium | Medium | Rotate tasks, document everything in README | All | Open |
| R3 | A password/token is committed to Git | Low | High | `.gitignore`, GitHub Secrets only, review every PR; if exposed: revoke, rotate, tell instructor | Hamza Alhazmi | Open |
| R4 | Bad release breaks the service | Medium | Medium | Health check after deploy, `scripts/rollback.sh` to previous release | Abdalrhman Alsamiri | Open |
| R5 | Running out of time near week 5 | Medium | High | Weekly check of task board, start report early | All | Open |
| R6 | Members of the `docker` group effectively have root access on the VM | Medium | High | Only the three named team accounts are in `docker`; no shared accounts; accepted because every member must deploy | Saud Alharbi | Accepted |
| R7 | `saud` is in the `lxd` group (root-equivalent, added by Ubuntu, LXD not used) | Low | High | Remove with `sudo gpasswd -d saud lxd` (planned process improvement, Part G) | Saud Alharbi | Open |
| R8 | Docker-published ports bypass the `ufw` firewall | Medium | Medium | Publish the app only on the host-only address: `BIND_ADDR=192.168.56.10 ./scripts/deploy.sh <version>`; never `0.0.0.0` | Abdalrhman Alsamiri | Open |
| R9 | Host runs Hyper-V, so VirtualBox is slow and the VM froze once | Medium | Medium | Snapshots; use SSH instead of the VM console; disable Hyper-V on the host if it happens again | Saud Alharbi | Open |
| R10 | GHCR image is private, so the VM cannot pull it | Medium | Medium | Make the package public (synthetic data only) or use the CI image archive (`docs/release-guide.md`, offline option) | Hamza Alhazmi | Open |
