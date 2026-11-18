# RB-001: Rollback from v1.1.0 to v1.0.0

Separate from INC-001: here we restore the previous known working artifact.

| Field | Value |
|---|---|
| Date | ________ |
| Performed by | ________ |
| From version | 1.1.0 (image ID `sha256:________`) |
| To version | 1.0.0 (image ID `sha256:________`) |

## Steps
```bash
docker ps                                            # shows 1.1.0 running
curl -s http://192.168.56.10:8080/health             # {"status":"ok","version":"1.1.0"}
BIND_ADDR=192.168.56.10 ./scripts/rollback.sh 1.0.0  # prints "done in N seconds"
curl -s http://192.168.56.10:8080/health             # {"status":"ok","version":"1.0.0"}
```

## Result
| Check | Result |
|---|---|
| `rollback.sh` output (time) | ____ seconds |
| `/health` after rollback | ________ |
| Version shown on the web page | ________ |
| Image ID now running (`docker inspect --format '{{.Image}}' service-info`) | ________ |
| Matches the v1.0.0 image ID from CI? | Yes / No |

## Notes
- ________
