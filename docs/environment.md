# Lab Environment

| Item | Value |
|---|---|
| Host | Windows 11 laptop (Intel Core i7-12650H), Oracle VirtualBox 7.2 |
| VM name / hostname | devops-vm / dev-opsvm |
| Guest OS | Ubuntu Server 26.04.1 LTS ("resolute"), kernel 7.0.0-43-generic |
| CPU | 2 vCPU |
| Memory | 4 GB assigned (3.3 GiB usable) + 3.8 GiB swap |
| Storage | 25 GB virtual disk, /dev/sda2 ext4 mounted at / (7.4 GB used at install) |
| Network adapter 1 (enp0s3) | NAT, 10.0.2.15/24 via DHCP, default gateway 10.0.2.2, internet for updates |
| Network adapter 2 (enp0s8) | Host-only, static 192.168.56.10/24, private lab network, no gateway |
| Docker bridge (docker0) | 172.17.0.1/16, created by Docker; each running container gets a `veth…` interface on it. The app is published only on 192.168.56.10:8080 |
| Remote access | OpenSSH server: `ssh saud@192.168.56.10` |
| Recovery snapshots | `01-clean-install` (2026-11-17, after install + updates); `02-before-v1.0.0` (2026-11-18, after firewall + Docker, before deploying v1.0.0, CR-001) |

## Known limitation
Windows Hyper-V is enabled on the host, so VirtualBox runs through the
Hyper-V "native API" engine (nested paging inactive). This made the VM slow,
caused a kernel soft-lockup warning during install, and froze console
keyboard input once (fixed by a VM reset). SSH access was unaffected.
Planned fix: disable Hyper-V / Memory Integrity on the host.

## Command output (2026-11-17)
```
== OS ==
Distributor ID: Ubuntu
Description:    Ubuntu 26.04.1 LTS
Release:        26.04
Codename:       resolute
7.0.0-43-generic
dev-opsvm
== CPU ==
2
CPU(s):                                  2
Model name:                              12th Gen Intel(R) Core(TM) i7-12650H
== Memory ==
               total        used        free      shared  buff/cache   available
Mem:           3.3Gi       514Mi       2.2Gi       1.1Mi       922Mi       2.8Gi
Swap:          3.8Gi          0B       3.8Gi
== Storage ==
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        25G  7.4G   16G  32% /
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda      8:0    0   25G  0 disk
├─sda1   8:1    0    1M  0 part
└─sda2   8:2    0   25G  0 part /
== Network ==
lo               UNKNOWN        127.0.0.1/8 ::1/128
enp0s3           UP             10.0.2.15/24
enp0s8           UP             192.168.56.10/24
default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15 metric 100
192.168.56.0/24 dev enp0s8 proto kernel scope link src 192.168.56.10
```

## Re-check after Docker and first deployment (2026-11-18, account `abdulrhman`)
```
abdulrhman@dev-opsvm:~$ lsb_release -d; uname -r; nproc; ip -br a
Description:    Ubuntu 26.04.1 LTS
7.0.0-43-generic
2
lo               UNKNOWN        127.0.0.1/8 ::1/128
enp0s3           UP             10.0.2.15/24
enp0s8           UP             192.168.56.10/24
docker0          UP             172.17.0.1/16
veth4e0b85f@if2  UP             fe80::e47b:7ff:fe94:18b5/64
```
