# Linux Setup – Firewall and Docker

VM details are in `docs/environment.md`; accounts and permissions are in
`docs/linux-admin.md`. This page covers the network controls and Docker.

## Firewall (ufw)
Only SSH (22) and the web app (8080) are allowed in, and only from the private
host-only network 192.168.56.0/24. Everything else coming in is blocked.

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 192.168.56.0/24 to any port 22 proto tcp comment 'SSH from lab network'
sudo ufw allow from 192.168.56.0/24 to any port 8080 proto tcp comment 'service-info web app'
sudo ufw enable
sudo ufw status verbose
```
The SSH rule is added before `ufw enable` so the session is not locked out.

Performed by: Abdalrhman Alsamiri on 2026-11-18 (rules typed in the open `saud`
SSH session). Re-checked from his own named account the same day:
```
abdulrhman@dev-opsvm:~$ id
uid=1001(abdulrhman) gid=1001(abdulrhman) groups=1001(abdulrhman),27(sudo),100(users),107(docker),1003(devops)
abdulrhman@dev-opsvm:~$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), deny (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    192.168.56.0/24            # SSH from lab network
8080/tcp                   ALLOW IN    192.168.56.0/24            # service-info web app
```
`deny (routed)` appeared after Docker was installed: Docker turns on packet
forwarding for containers, and ufw's default for forwarded traffic is deny.
Docker adds its own rules for published ports ahead of ufw (risk R8).

`sudo ufw status verbose` output:
```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    192.168.56.0/24            # SSH from lab network
8080/tcp                   ALLOW IN    192.168.56.0/24            # service-info web app
```
What it tells an operator: the firewall is on, everything coming in is denied
unless a rule allows it, and only ports 22 and 8080 are open, only to the
private lab network.

## Authorized connectivity check (from the Windows host)
```powershell
Test-NetConnection 192.168.56.10 -Port 22     # expected: TcpTestSucceeded : True
Test-NetConnection 192.168.56.10 -Port 3306   # expected: TcpTestSucceeded : False (blocked)
```
Output (2026-11-18, from the Windows host 192.168.56.1):
```
PS> Test-NetConnection 192.168.56.10 -Port 22
RemoteAddress    : 192.168.56.10
RemotePort       : 22
SourceAddress    : 192.168.56.1
TcpTestSucceeded : True

PS> Test-NetConnection 192.168.56.10 -Port 3306
WARNING: TCP connect to (192.168.56.10 : 3306) failed
RemoteAddress          : 192.168.56.10
RemotePort             : 3306
PingSucceeded          : True
TcpTestSucceeded       : False
```
Port 22 is allowed. For port 3306 the VM answers ping (it is up and reachable)
but the TCP connection fails, so the firewall is what blocks it.

## Docker
```bash
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker saud
sudo usermod -aG docker abdulrhman
sudo usermod -aG docker hamza
```
Log out and in again, then:
```
$ docker --version
Docker version 29.1.3, build 29.1.3-0ubuntu4.1

$ systemctl status docker --no-pager | head -5
● docker.service - Docker Application Container Engine
     Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; preset: enabled)
     Active: active (running) since Wed 2026-11-18 12:29:11 UTC; 6min ago
TriggeredBy: ● docker.socket

$ docker run --rm hello-world
...
Hello from Docker!
This message shows that your installation appears to be working correctly.
```
Docker is installed, running, starts at boot (`enabled`), and the `saud` account
can use it without `sudo` because it is in the `docker` group.

## Security notes
- The `docker` group is root-equivalent. Only the three named accounts are in it
  (risk R6 in `records/risk-register.md`).
- Ports published by Docker bypass `ufw`. The app is therefore published only on
  the host-only address: `BIND_ADDR=192.168.56.10 ./scripts/deploy.sh <version>`
  (risk R8).
- The container itself runs as `appuser` (UID 10001), not root (`Dockerfile`).
