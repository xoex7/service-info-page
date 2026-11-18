# Weekly Update – Week 1 (draft, check before sending)

**To:** Instructor (stakeholder) **From:** Saud Alharbi, Abdalrhman Alsamiri, Hamza Alhazmi
**Date sent:** ________ **Channel:** ________

## Completed
- Team plan, roles, risk register and task board set up; `main` protected (PR + 1 approval).
- Lab VM `dev-opsvm` created: Ubuntu Server 26.04.1 LTS, 2 vCPU, 4 GB RAM, 25 GB disk,
  NAT + private host-only network 192.168.56.10; recovery snapshot `01-clean-install`.
- Named accounts for all three members, `devops` group, shared folder
  `/opt/service-info` (mode 2770), sudo limited to two members.
- Flask service with `/health`, 4 automated tests, flake8, Dockerfile (non-root),
  and a CI pipeline that builds and keeps a versioned image only after checks pass (PR #7).
- Tag `v1.0.0` created; CI built the image.

## Next
- Firewall (`ufw`) and Docker on the VM; deploy v1.0.0 with change record CR-001.
- Demonstrate a failed CI run and its correction.
- Review and merge PRs #8, #9 and #10; release v1.1.0 (CR-002).

## Risks
- Host laptop runs Hyper-V, which makes the VM slow (one console freeze; SSH unaffected).
- Docker-published ports bypass `ufw`; we will publish only on 192.168.56.10.

## Decisions needed
- None this week.
