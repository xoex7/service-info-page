# RB-001: Rollback from v1.1.0 to v1.0.0

Separate from INC-001: here we restore the previous known working artifact,
then roll forward again to the current release.

| Field | Value |
|---|---|
| Date | 2026-11-19 (UTC) |
| Performed by | Abdalrhman Alsamiri (own account `abdulrhman`) |
| From version | 1.1.0 (image ID `sha256:fa8dc360d10f868e90d39f9f2c2d7a11e27bfa6cfc6379f0980fd83bccea0de8`, CR-002) |
| To version | 1.0.0 (image ID `sha256:783bd215eb1e938e769557128203661f14ab18364350d9714ddeea9731ce9dea`, CR-001) |

## Result
| Check | Result |
|---|---|
| Before: `/health` | `{"status":"ok","version":"1.1.0"}` |
| Before: running image | `sha256:fa8dc360…` (v1.1.0) |
| `rollback.sh` with no version | **Failed:** `No previous version known. Give one: ./scripts/rollback.sh 1.0.0` (see finding below) |
| `rollback.sh 1.0.0` | Started 21:14:37Z, HEALTHY 21:14:39Z: **done in 2 seconds** |
| After: `/health` | `{"status":"ok","version":"1.0.0"}` |
| After: running image | `sha256:783bd215…`, **matches** the v1.0.0 image from CI run #3 / CR-001 |
| Roll forward | `deploy.sh 1.1.0` at 21:15:24Z, HEALTHY 21:15:26Z, image `sha256:fa8dc360…` again |

## Output
```
abdulrhman@dev-opsvm:~/service-info-page$ curl -s http://192.168.56.10:8080/health; echo
{"status":"ok","version":"1.1.0"}
abdulrhman@dev-opsvm:~/service-info-page$ docker inspect --format '{{.Image}}' service-info
sha256:fa8dc360d10f868e90d39f9f2c2d7a11e27bfa6cfc6379f0980fd83bccea0de8
abdulrhman@dev-opsvm:~/service-info-page$ bash scripts/rollback.sh
No previous version known. Give one: ./scripts/rollback.sh 1.0.0
abdulrhman@dev-opsvm:~/service-info-page$ bash scripts/rollback.sh 1.0.0
2026-11-19T21:14:37+00:00 Rolling back to 1.0.0
2026-11-19T21:14:37+00:00 Deploying ghcr.io/xoex7/service-info-page:1.0.0
46d68c2014d356fa94f3863e6720baf0706b93cf398062c4ab4d823e853d079a
2026-11-19T21:14:39+00:00 HEALTHY http://192.168.56.10:8080/health -> {"status":"ok","version":"1.0.0"}
Deployed image ID: sha256:783bd215eb1e938e769557128203661f14ab18364350d9714ddeea9731ce9dea
2026-11-19T21:14:39+00:00 rollback to 1.0.0 done in 2 seconds
abdulrhman@dev-opsvm:~/service-info-page$ curl -s http://192.168.56.10:8080/health; echo
{"status":"ok","version":"1.0.0"}
abdulrhman@dev-opsvm:~/service-info-page$ docker inspect --format '{{.Image}}' service-info
sha256:783bd215eb1e938e769557128203661f14ab18364350d9714ddeea9731ce9dea
abdulrhman@dev-opsvm:~/service-info-page$ bash scripts/deploy.sh 1.1.0
2026-11-19T21:15:24+00:00 Deploying ghcr.io/xoex7/service-info-page:1.1.0
dce1ad4efbaa058b805c8863b3db9dba9b4a624c0ec08dc4730d2a4a42543f67
2026-11-19T21:15:26+00:00 HEALTHY http://192.168.56.10:8080/health -> {"status":"ok","version":"1.1.0"}
Deployed image ID: sha256:fa8dc360d10f868e90d39f9f2c2d7a11e27bfa6cfc6379f0980fd83bccea0de8
```

## Findings
- **Rollback is fast because the old image is kept on the VM:** no download, just replace
  the container (2 s). Deleting old images would make rollback slower and depend on GHCR.
- **`rollback.sh` without a version does not work across team members.** `deploy.sh` saves
  the current/previous version in `$HOME/.service-info` of whoever ran it. v1.1.0 was
  deployed by `hamza`, so `abdulrhman` had no history and had to know the version number.
  In a real incident that is extra thinking time (compare INC-001). Candidate for the
  Part G improvement: a shared deployment history for the `devops` group.
- **VM instability before the test:** on 2026-11-19 the VM froze several times (kernel soft
  lockups of 34 s, 142 s and 419 s; `ssh.service` failed to start once) and needed a reset
  before this test. Cause: Hyper-V on the host (risk R9). The rollback itself was not affected.
