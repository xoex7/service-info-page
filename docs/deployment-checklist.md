# Deployment Checklist

Copy this list into the change record for every deployment and tick each item.
Do the sections **in order**. Do not start section 4 until sections 1–3 are ticked.

## 1. Prerequisites
- [ ] VM is running
- [ ] `docker ps` works for the deploying user (member of `docker` group)
- [ ] Disk space OK: `df -h /` shows more than 2 GB free
- [ ] Repo on VM is up to date: `git pull`

## 2. Approval
- [ ] Change record `CR-___` written by: ________
- [ ] Approved by (different person): ________  Date/time: ________

## 2b. Stop point: snapshot (added after CR-002)
- [ ] **Deployer** checks in VirtualBox (Snapshots tab) that snapshot `NN-before-v<version>`
      exists and was taken **after** the approval: name ________ time ________
- [ ] Only then continue. In CR-002 the snapshot was taken one minute after the
      deployment because nothing stopped the deployer; this step closes that gap.

## 3. Artifact identifier
- [ ] Release version: ________
- [ ] Git commit SHA: ________
- [ ] CI run link (green): ________
- [ ] Image ID from `build-info.txt`: ________

## 4. Deployment steps
```bash
cd ~/service-info-page && git pull
docker pull ghcr.io/xoex7/service-info-page:<version>
docker image inspect --format '{{index .RepoDigests 0}}' ghcr.io/xoex7/service-info-page:<version>
bash scripts/deploy.sh <version>          # BIND_ADDR defaults to 192.168.56.10
```
- [ ] Digest on VM matches `image_id` in `build-info.txt` from CI (before running deploy.sh)
- [ ] deploy.sh printed `HEALTHY` and the expected version

## 5. Health check
- [ ] `./scripts/healthcheck.sh http://192.168.56.10:8080/health` prints `HEALTHY`
- [ ] `docker ps` shows `(healthy)`
- [ ] Web page shows the expected version
- [ ] `docker logs --tail 20 service-info` has no errors

## 6. Rollback (if any check fails)
```bash
bash scripts/rollback.sh <previous-version>     # e.g. 1.0.0
bash scripts/healthcheck.sh http://192.168.56.10:8080/health
```
- [ ] Previous version is shown and healthy
- [ ] Rollback time recorded: ____ seconds
- [ ] Incident update sent to instructor (see `records/incidents/`)
