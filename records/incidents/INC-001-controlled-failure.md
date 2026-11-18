# Incident INC-001: Controlled failure (simulation)

> **SIMULATION.** This failure was caused on purpose in our own lab VM to
> practise detection and recovery. No real users were affected.

| Field | Value |
|---|---|
| Date | ________ |
| Service / version | Campus Print Service, v______ |
| Performed by | ________ |
| Observed / recovered by | ________ |

## What we did (the controlled failure)
```bash
docker stop service-info
```

## Timeline (fill in real times, `date -Is` output)
| Time | Event |
|---|---|
| ________ | Failure caused: `docker stop service-info` |
| ________ | **Detected**: `./scripts/healthcheck.sh` printed `UNHEALTHY` |
| ________ | Recovery started |
| ________ | **Recovered**: health check printed `HEALTHY` |

Time to detect: ____ seconds. Time to recover: ____ seconds.

## Symptoms
- `./scripts/healthcheck.sh http://192.168.56.10:8080/health` output: ________
- `docker ps -a` showed: ________
- Browser showed: ________

## Recovery action
```bash
docker start service-info
./scripts/healthcheck.sh http://192.168.56.10:8080/health
```
Output after recovery: ________

## Why `--restart unless-stopped` did not bring it back
The container was stopped by hand with `docker stop`. Docker treats a manual
stop as intentional, so the restart policy does not start it again until
someone runs `docker start` (or Docker restarts).

## Stakeholder update (sent to the instructor)
Sent at ________ via ________. Text:

> **[SIMULATION] Incident update – Campus Print Service**
> At ____ we stopped the service on purpose as a recovery exercise.
> The health check detected the outage at ____. We restarted the container
> at ____ and the health check passed at ____ (total ____ s). No data was lost.
> Next step: ________.

## Lessons / follow-up
- ________
