# Deployment Checklist

Copy this list into the change record for every deployment and tick each item.

## 1. Prerequisites
- [ ] VM is running; recovery snapshot taken (name: ________)
- [ ] `docker ps` works for the deploying user (member of `docker` group)
- [ ] Disk space OK: `df -h /` shows more than 2 GB free
- [ ] Repo on VM is up to date: `git pull`

## 2. Approval
- [ ] Change record `CR-___` written by: ________
- [ ] Approved by (different person): ________  Date/time: ________

## 3. Artifact identifier
- [ ] Release version: ________
- [ ] Git commit SHA: ________
- [ ] CI run link (green): ________
- [ ] Image ID from `build-info.txt`: ________

## 4. Deployment steps
```bash
./scripts/deploy.sh <version>
docker image inspect --format '{{.Id}}' ghcr.io/xoex7/service-info-page:<version>
```
- [ ] Image ID on VM matches image ID from CI

## 5. Health check
- [ ] `./scripts/healthcheck.sh` prints `HEALTHY`
- [ ] `docker ps` shows `(healthy)`
- [ ] Web page shows the expected version
- [ ] `docker logs --tail 20 service-info` has no errors

## 6. Rollback (if any check fails)
```bash
./scripts/rollback.sh            # previous version
./scripts/healthcheck.sh
```
- [ ] Previous version is shown and healthy
- [ ] Rollback time recorded: ____ seconds
- [ ] Incident update sent to instructor (see `records/incidents/`)
