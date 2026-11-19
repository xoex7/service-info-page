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

Pull request: #____ (reviewed by ________).

## How we measured it
Same test as the "before", with different people deploying and rolling back:

1. Saud deploys v1.0.0, then Hamza deploys v1.1.0 (two different accounts).
2. Abdalrhman runs `bash scripts/rollback.sh` **without a version**.
3. Check the version, the image ID and `/opt/service-info/state/history.log`.

| | Before (RB-001) | After |
|---|---|---|
| `rollback.sh` with no version, run by someone who did not deploy | Failed: "No previous version known" | ________ |
| Rollback target found automatically | No (had to type 1.0.0) | ________ |
| History shows who deployed | No (and split across 3 home folders) | ________ |
| Rollback time | 2 s (once the version was typed) | ________ |

## Evidence (after)
```
(paste the terminal output of steps 1–3 here)
```

## Result
________
