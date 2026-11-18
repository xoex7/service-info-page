# Linux Administration

## Named accounts and least privilege
| User | UID | Groups | Role |
|---|---|---|---|
| saud | 1000 | sudo, devops, docker | Linux lead, admin |
| abdulrhman | 1001 | sudo, devops, docker | Backup admin |
| hamza | 1002 | devops, docker | Developer, no admin rights |

- Every student uses a personal account (no shared logins), so actions in logs are traceable to a person.
- Admin (sudo) is limited to two people; one admin would be a single point of failure.
- Commands used: `adduser`, `groupadd devops`, `usermod -aG devops <user>`, `usermod -aG sudo abdulrhman`.
- All three are in the `docker` group (added in Step 3B, `docs/linux-setup.md`) because every
  member deploys or recovers the service. Docker group membership is root-equivalent, so it is
  limited to these three named accounts and recorded as risk R6 in `records/risk-register.md`.
  Verified with `id abdulrhman`: `groups=...,27(sudo),...,107(docker),1003(devops)`.

## Project directory
```
$ ls -ld /opt/service-info
drwxrws--- 2 root devops 4096 Nov 17 09:05 /opt/service-info
```
- Mode `2770`: owner and `devops` group have full access; all other users have none.
- The setgid bit (`s`) makes new files inherit the `devops` group so team members can edit each other's files.

## Resource, process and service checks
```
$ ps -eo pid,user,%cpu,%mem,cmd --sort=-%mem | head -6
  842 root  0.2 1.2 /usr/lib/snapd/snapd
  ...
$ systemctl status ssh --no-pager | head -5
● ssh.service - OpenBSD Secure Shell server
     Active: active (running) ... TriggeredBy: ● ssh.socket
```
- Low CPU/memory use: the VM is idle and healthy.
- SSH is socket-activated: `ssh.socket` listens on port 22 and starts `ssh.service` on connection.

## Known issue (candidate improvement)
`saud` is a member of `lxd`, which grants root-equivalent access. LXD is not used in this project, so this is unnecessary privilege.
