# Process Improvement (Part G): shared deployment history

## Weakness found
`deploy.sh` saved the deployment history (`current`, `previous`, `history.log`)
in `$HOME/.service-info` of **whoever ran it**. Our team rotates deployments
(Saud deployed v1.0.0, Hamza deployed v1.1.0), so each person had a different,
incomplete history.

**Evidence (before), RB-001, 2026-11-19, account `abdulrhman`:**
```
abdulrhman@dev-opsvm:~/service-info-page$ bash scripts/rollback.sh
No previous version known. Give one: ./scripts/rollback.sh 1.0.0
```
The automatic rollback failed. The person responding had to know the previous
version number himself, and the history did not show who deployed what. In
INC-001 we saw that "working out what to do" is the slowest part of recovery
(2 min 14 s of a 2 min 46 s outage), so a rollback that needs extra knowledge
is a real risk.

## Change
- `deploy.sh` and `rollback.sh` now keep the history in **`/opt/service-info/state`**,
  inside the shared project folder from `docs/linux-admin.md` (owner `root:devops`,
  mode `2770`, setgid). New files inherit the `devops` group, and `umask 0002`
  keeps them group-writable, so every team member reads and updates the same history.
  Users outside `devops` still have no access.
- Each history line records **who** deployed or rolled back (`id -un`).
- A second bug found while testing: re-deploying the version that is already running
  copied `current` into `previous`, so `previous` pointed to itself and rollback did
  nothing. `deploy.sh` now only updates `previous` when the version changes.
- If the history folder is not writable, the script stops with a clear message
  ("Are you in the devops group?") instead of failing halfway.

Pull request: [#23](https://github.com/xoex7/service-info-page/pull/23) (approved by Abdalrhman, merged 2026-11-19).

## How we measured it
Same test as the "before", with different people deploying and rolling back:

1. Saud deploys v1.0.0, then Hamza deploys v1.1.0 (two different accounts).
2. Abdalrhman runs `bash scripts/rollback.sh` **without a version**.
3. Check the version, the image ID and `/opt/service-info/state/history.log`.

| | Before (RB-001) | After |
|---|---|---|
| `rollback.sh` with no version, run by someone who did not deploy | Failed: "No previous version known" | **Worked:** "Rolling back to 1.0.0", HEALTHY on 1.0.0 |
| Rollback target found automatically | No (had to type 1.0.0) | **Yes**, both back (1.1.0 → 1.0.0) and forward (1.0.0 → 1.1.0) |
| History shows who deployed | No (and split across 3 home folders) | **Yes**, one file with `saud`, `hamza` and `abdulrhman` |
| Rollback time | 2 s (once the version was typed) | Healthy after 4 s (script reported 75 s because the VM froze right after, see note); roll forward 2 s |

## Evidence (after), 2026-11-19, three different accounts
```
saud@dev-opsvm:~/service-info-page$ bash scripts/deploy.sh 1.0.0          # 21:47:28 OK (see history)

hamza@dev-opsvm:~/service-info-page$ bash scripts/deploy.sh 1.1.0
2026-11-19T21:49:06+00:00 Deploying ghcr.io/xoex7/service-info-page:1.1.0
2026-11-19T21:49:11+00:00 HEALTHY http://192.168.56.10:8080/health -> {"status":"ok","version":"1.1.0"}
Deployed image ID: sha256:fa8dc360d10f868e90d39f9f2c2d7a11e27bfa6cfc6379f0980fd83bccea0de8

abdulrhman@dev-opsvm:~/service-info-page$ bash scripts/rollback.sh
2026-11-19T21:50:25+00:00 Rolling back to 1.0.0
2026-11-19T21:50:25+00:00 Deploying ghcr.io/xoex7/service-info-page:1.0.0
2026-11-19T21:50:29+00:00 HEALTHY http://192.168.56.10:8080/health -> {"status":"ok","version":"1.0.0"}
Deployed image ID: sha256:783bd215eb1e938e769557128203661f14ab18364350d9714ddeea9731ce9dea
2026-11-19T21:51:40+00:00 abdulrhman rollback to 1.0.0 done in 75 seconds

abdulrhman@dev-opsvm:~/service-info-page$ cat /opt/service-info/state/history.log
2026-11-19T21:47:28+00:00 saud deploy 1.0.0 OK
2026-11-19T21:49:11+00:00 hamza deploy 1.1.0 OK
2026-11-19T21:50:29+00:00 abdulrhman deploy 1.0.0 OK
2026-11-19T21:51:40+00:00 abdulrhman rollback to 1.0.0 done in 75 seconds

abdulrhman@dev-opsvm:~/service-info-page$ ls -l /opt/service-info/state
-rw-rw-r-- 1 saud  devops   6 Nov 19 21:50 current
-rw-rw-r-- 1 saud  devops 222 Nov 19 21:51 history.log
-rw-rw-r-- 1 hamza devops   6 Nov 19 21:50 previous

abdulrhman@dev-opsvm:~/service-info-page$ bash scripts/rollback.sh
2026-11-19T21:52:58+00:00 Rolling back to 1.1.0
2026-11-19T21:53:00+00:00 HEALTHY http://192.168.56.10:8080/health -> {"status":"ok","version":"1.1.0"}
Deployed image ID: sha256:fa8dc360d10f868e90d39f9f2c2d7a11e27bfa6cfc6379f0980fd83bccea0de8
2026-11-19T21:53:00+00:00 abdulrhman rollback to 1.1.0 done in 2 seconds
```

**Note on the 75 seconds:** the service was healthy 4 s after the rollback started
(21:50:25 → 21:50:29). The VM console showed `soft lockup - CPU#0 stuck for 67s! [docker:3131]`
at the same moment, so the script itself was paused before it could print the final line.
This is risk R9 (Hyper-V on the host), not the rollback. The roll forward 2 minutes later,
without a freeze, took 2 s.

## Result
The weakness is fixed and measured. Any member of the `devops` group can now roll back with
one command after **someone else** deployed, without knowing the version number: the step that
failed in RB-001 now works, in both directions. The shared history also shows who changed what,
and the files written by `saud` and `hamza` stayed writable for `abdulrhman` through the group,
while users outside `devops` still have no access (`/opt/service-info` is mode 2770).
Old per-user files in `~/.service-info` are no longer used.
