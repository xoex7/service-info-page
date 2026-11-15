# Linux VM Setup (Steps 2–3, owner: Saud)

Record the real values from your VM here.

| Item | Value | Command used |
|---|---|---|
| OS | | `lsb_release -a` |
| CPU | | `nproc`, `lscpu` |
| Memory | | `free -h` |
| Storage | | `df -h /` |
| Network | | `ip a` (VirtualBox: Host-only / NAT network) |
| Snapshot | | VirtualBox → Snapshots |

Docker install and allowing named users to run it:

```bash
sudo apt update && sudo apt install -y docker.io git curl python3-venv
sudo systemctl enable --now docker
sudo usermod -aG docker <username>   # then log out and in again
```

Paste the accounts, permissions and firewall (`sudo ufw status verbose`) evidence below.
