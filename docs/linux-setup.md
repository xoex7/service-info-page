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

Performed by: ________ (own account) on ________

`sudo ufw status verbose` output:
```
(paste here)
```

## Authorized connectivity check (from the Windows host)
```powershell
Test-NetConnection 192.168.56.10 -Port 22     # expected: TcpTestSucceeded : True
Test-NetConnection 192.168.56.10 -Port 3306   # expected: TcpTestSucceeded : False (blocked)
```
Output:
```
(paste here)
```

## Docker
```bash
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker saud
sudo usermod -aG docker abdulrhman
sudo usermod -aG docker hamza
```
Log out and in again, then:
```bash
docker --version
systemctl status docker --no-pager | head -5
docker run --rm hello-world
```
Output:
```
(paste here)
```

## Security notes
- The `docker` group is root-equivalent. Only the three named accounts are in it
  (risk R6 in `records/risk-register.md`).
- Ports published by Docker bypass `ufw`. The app is therefore published only on
  the host-only address: `BIND_ADDR=192.168.56.10 ./scripts/deploy.sh <version>`
  (risk R8).
- The container itself runs as `appuser` (UID 10001), not root (`Dockerfile`).
