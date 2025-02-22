# How to Set Up SSH in Ubuntu Server

1. Install the openssh-server package 

```bash
sudo apt-get install openssh-server

Reading package lists...
Building dependency tree...
Reading state information...
openssh-server is already the newest version (1:9.6p1-3ubuntu13.8).
0 upgraded, 0 newly installed, 0 to remove and 161 not upgraded.
```

1. Enable the ssh service 

```bash
sudo systemctl enable ssh

soeyehtet@ubuntu:~$ sudo systemctl status ssh
[sudo] password for soeyehtet:
Sorry, try again.
[sudo] password for soeyehtet:
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/usr/lib/systemd/system/ssh.service; enabled; preset: enabled)
     Active: active (running) since Sat 2025-02-22 18:39:37 UTC; 3min 2s ago
TriggeredBy: ● ssh.socket
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 2750 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 2751 (sshd)
      Tasks: 1 (limit: 2218)
     Memory: 2.2M (peak: 3.1M)
        CPU: 33ms
     CGroup: /system.slice/ssh.service
             └─2751 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Feb 22 18:39:37 ubuntu systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...
Feb 22 18:39:37 ubuntu sshd[2751]: Server listening on :: port 22.
Feb 22 18:39:37 ubuntu systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
Feb 22 18:39:40 ubuntu sshd[2753]: Accepted password for soeyehtet from 192.168.211.1 port 53543 ssh2
Feb 22 18:39:40 ubuntu sshd[2753]: pam_unix(sshd:session): session opened for user soeyehtet(uid=1000) by soeyehtet(uid
```

1. Remote log-in to the server

```bash
PS C:\Users\soeye> ssh soeyehtet@192.168.211.129
soeyehtet@192.168.211.129's password:
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-52-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro
```