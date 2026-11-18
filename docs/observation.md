# Observing the Service

Commands an operator uses on `dev-opsvm` to see whether the service is healthy,
with real output from 2026-11-18 (run by Hamza, account `hamza`, v1.1.0 deployed).

| Command | What it tells the operator |
|---|---|
| `docker ps --filter name=service-info` | Is the container running, which image/version, Docker's own health status `(healthy)`, which address/port is published |
| `docker logs --tail 10 service-info` | What the app printed: requests and errors. First place to look when something is wrong |
| `bash scripts/healthcheck.sh http://192.168.56.10:8080/health` | Does the service answer correctly from outside the container (`HEALTHY` + version) |
| `df -h /` | Disk space; a full disk stops Docker from writing images and logs |
| `systemctl status docker --no-pager \| head -4` | Is the Docker engine itself running and enabled at boot |

## Output
```
$ docker ps --filter name=service-info
CONTAINER ID   IMAGE                                   COMMAND                  CREATED         STATUS                   PORTS                            NAMES
ae72d3126ab0   ghcr.io/xoex7/service-info-page:1.1.0   "gunicorn --bind 0.0…"   9 minutes ago   Up 9 minutes (healthy)   192.168.56.10:8080->5000/tcp     service-info

$ docker logs --tail 10 service-info
[2026-11-18 21:45:49 +0000] [1] [CRITICAL] WORKER TIMEOUT (pid:68)
[2026-11-18 21:45:49 +0000] [67] [INFO] Worker exiting (pid: 67)
[2026-11-18 21:45:49 +0000] [68] [INFO] Worker exiting (pid: 68)
[2026-11-18 21:45:49 +0000] [1] [ERROR] Worker (pid:67) exited with code 1
[2026-11-18 21:45:49 +0000] [83] [INFO] Booting worker with pid: 83
[2026-11-18 21:45:49 +0000] [1] [ERROR] Worker (pid:68) was sent SIGKILL! Perhaps out of memory?
[2026-11-18 21:45:49 +0000] [84] [INFO] Booting worker with pid: 84
127.0.0.1 - - [18/Nov/2026:21:45:50 +0000] "GET /health HTTP/1.1" 200 34 "-" "Python-urllib/3.12"
127.0.0.1 - - [18/Nov/2026:21:46:21 +0000] "GET /health HTTP/1.1" 200 34 "-" "Python-urllib/3.12"

$ bash scripts/healthcheck.sh http://192.168.56.10:8080/health
2026-11-18T21:46:31+00:00 HEALTHY http://192.168.56.10:8080/health -> {"status":"ok","version":"1.1.0"}

$ df -h /
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        25G  7.7G   16G  33% /

$ systemctl status docker --no-pager | head -4
● docker.service - Docker Application Container Engine
     Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; preset: enabled)
     Active: active (running) since Wed 2026-11-18 19:54:45 UTC; 1h 51min ago
```

## What we read from it
- **Healthy:** container `Up (healthy)`, health check `HEALTHY` with version 1.1.0, published only on 192.168.56.10.
- **Disk is fine:** 33% used, 16 GB free.
- **Docker is running** and starts at boot (`enabled`).
- **Warning found in the logs:** at 21:45:49 gunicorn killed two workers that did not answer in time
  (`WORKER TIMEOUT`, `SIGKILL`). Memory is not the cause (VM has 3.3 GiB, the app is tiny); the VM
  pauses because the host runs Hyper-V (risk R9, also seen as a kernel soft lockup during install).
  gunicorn started new workers at once and the `/health` requests one second later returned 200, so
  users would at most have seen one slow request. The `(healthy)` status and the 200 responses show
  the service recovered without help.
