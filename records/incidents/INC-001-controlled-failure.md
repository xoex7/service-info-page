# Incident INC-001: Controlled failure (simulation)

> **SIMULATION.** This failure was caused on purpose in our own lab VM to
> practise detection and recovery. No real users were affected. The instructor
> was told before the exercise started.

| Field | Value |
|---|---|
| Date | 2026-11-18 |
| Service / version | Campus Print Service, v1.1.0 (`ghcr.io/xoex7/service-info-page:1.1.0`) |
| Performed, detected and recovered by | Hamza Alhazmi (own account `hamza`), watched by Saud and Abdalrhman |
| Severity | Full outage of the service page and `/health` |

## What we did (the controlled failure)
```bash
docker stop service-info
```

## Timeline (UTC, from `date -Is` and the health check output)
| Time | Event |
|---|---|
| 21:46:31 | Baseline: `healthcheck.sh` printed `HEALTHY ... {"status":"ok","version":"1.1.0"}` |
| **21:47:48** | **Failure caused:** `docker stop service-info` |
| **21:48:13** | **Detected:** `healthcheck.sh` printed `UNHEALTHY: no good answer ... after 15 tries` |
| 21:48 | `docker ps -a` showed `Exited (0)`; browser showed `ERR_CONNECTION_REFUSED` |
| **21:50:27** | **Recovery started:** `docker start service-info` |
| **21:50:34** | **Recovered:** `HEALTHY ... {"status":"ok","version":"1.1.0"}`; `docker ps` shows `Up (healthy)` |

| Measure | Value |
|---|---|
| Time to detect | 25 s (the health check retries 15 times before reporting) |
| Time from detection to starting recovery | 2 min 14 s |
| Time to recover once started | 7 s |
| **Total outage** | **2 min 46 s** |

## Symptoms
- `healthcheck.sh`: `2026-11-18T21:48:13+00:00 UNHEALTHY: no good answer from http://192.168.56.10:8080/health after 15 tries`
- `docker ps -a`: `service-info ... Exited (0) 2 minutes ago` (exit code 0 = clean stop, not a crash)
- Browser on the Windows host: "This site can't be reached – ERR_CONNECTION_REFUSED" (nothing listening on port 8080)

## Recovery action
```bash
docker start service-info
bash scripts/healthcheck.sh http://192.168.56.10:8080/health
# 2026-11-18T21:50:34+00:00 HEALTHY http://192.168.56.10:8080/health -> {"status":"ok","version":"1.1.0"}
```
The same container (same image, v1.1.0) was started again; no redeploy was needed.
A second `docker start` at 21:51:35 had no effect because the container was already running.

## Why `--restart unless-stopped` did not bring it back
The container was stopped by hand with `docker stop`. Docker treats a manual stop as
intentional, so the restart policy does not start it again until someone runs
`docker start` (or the Docker service restarts). A real crash (non-zero exit) would
have been restarted automatically.

## Stakeholder update (sent to the instructor)
Sent at ________ via ________ by ________. Text:

> **[SIMULATION] Incident update – Campus Print Service**
> As planned, we stopped the service at 21:47:48 UTC as a recovery exercise.
> Our health check detected the outage at 21:48:13. We restarted the container
> at 21:50:27 and the health check passed at 21:50:34. Total outage: 2 min 46 s;
> no data was lost and the same version (1.1.0) is running.
> Lesson: the fix took 7 seconds, but starting it took over 2 minutes, so we are
> adding a short recovery runbook to the README.

## Lessons / follow-up
- **Detection worked:** the health check reported the outage 25 s after the failure.
- **The slow part was deciding what to do** (2 min 14 s), not the fix (7 s). Action: a
  short "service is down" runbook in the README (check `docker ps -a` → `docker start` →
  health check → if that fails, `deploy.sh <current version>`).
- **Unrelated finding from the logs:** at 21:45:49, before the exercise, gunicorn logged
  `WORKER TIMEOUT` and `Worker ... was sent SIGKILL! Perhaps out of memory?`. Workers were
  restarted automatically and `/health` kept answering. This matches risk R9 (Hyper-V on
  the host makes the VM stall); see `docs/observation.md`.
