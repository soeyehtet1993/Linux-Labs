# Network Time Protocol

In this lab, we will practice how to set up time servers in ubuntu. 

We can check the list of timezone as per following. 

```bash
server@server:~$ timedatectl list-timezones 
Africa/Abidjan
Africa/Accra
Africa/Addis_Ababa
Africa/Algiers
Africa/Asmara
Africa/Asmera
Africa/Bamako
Africa/Bangui
Africa/Banjul
Africa/Bissau
Africa/Blantyre
Africa/Brazzaville
Africa/Bujumbura
Africa/Cairo
Africa/Casablanca
Africa/Ceuta
Africa/Conakry
Africa/Dakar
Africa/Dar_es_Salaam
Africa/Djibouti
Africa/Douala
Africa/El_Aaiun
Africa/Freetown
```

The naming format is “continent/city”. 

Now let set the time zone to Amercia/Los_Angeles

```bash
server@server:~$ sudo timedatectl set-timezone America/Los_Angeles 
[sudo] password for server: 

server@server:~$ timedatectl 
               Local time: Sun 2025-03-02 18:51:18 PST
           Universal time: Mon 2025-03-03 02:51:18 UTC
                 RTC time: Mon 2025-03-03 02:51:19
                Time zone: America/Los_Angeles (PST, -0800)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
server@server:~$ 

```

Now we can see that we set America/Los_Angeles timezone in our system.

If we forget the command we can check with “aporpos” command

```bash
server@server:~$ apropos system time | grep 'system time'
clock_t (3type)      - system time
timedatectl (1)      - Control the system time and date

```

The NTP package to install in Ubuntu is “systemd-timesyncd” but that package has been already installed in our system.

```bash
server@server:~$ sudo apt install systemd-timesyncd 
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
systemd-timesyncd is already the newest version (255.4-1ubuntu8.5).
systemd-timesyncd set to manually installed.
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
```

To turn on synchronization with NTP servers is 

```bash
server@server:~$ sudo timedatectl set-ntp true 
```

If we want to check the timesyncd service we can do as per following.

```bash
server@server:~$ sudo systemctl status systemd-timesyncd.service 
● systemd-timesyncd.service - Network Time Synchronization
     Loaded: loaded (/usr/lib/systemd/system/systemd-timesyncd.service; enabled>
     Active: active (running) since Sun 2025-03-02 18:44:59 PST; 17min ago
       Docs: man:systemd-timesyncd.service(8)
   Main PID: 627 (systemd-timesyn)
     Status: "Contacted time server 185.125.190.58:123 (ntp.ubuntu.com)."
      Tasks: 2 (limit: 4609)
     Memory: 1.4M (peak: 1.9M)
        CPU: 56ms
     CGroup: /system.slice/systemd-timesyncd.service
             └─627 /usr/lib/systemd/systemd-timesyncd

Mar 02 18:44:59 server systemd[1]: Starting systemd-timesyncd.service - Network>
Mar 02 18:44:59 server systemd[1]: Started systemd-timesyncd.service - Network >
Mar 02 18:45:00 server systemd-timesyncd[627]: Network configuration changed, t>
Mar 02 18:45:07 server systemd-timesyncd[627]: Network configuration changed, t>
Mar 02 18:45:07 server systemd-timesyncd[627]: Network configuration changed, t>
Mar 02 18:45:07 server systemd-timesyncd[627]: Network configuration changed, t>
Mar 02 18:45:07 server systemd-timesyncd[627]: Network configuration changed, t>
Mar 02 18:45:37 server systemd-timesyncd[627]: Contacted time server 185.125.19>
Mar 02 18:45:37 serve
```

## Change setting of systemd time synchronization daemon

The configuration path is “/etc/systemd/timesyncd.conf”

```bash
server@server:~$ sudo vim /etc/systemd/timesyncd.conf 
server@server:~$ cat /etc/systemd/timesyncd.conf | grep 'ntp'
NTP=0.us.pool.ntp.org 1.us.pool.ntp.org 2.us.pool.ntp.org 3.us.pool.ntp.org

server@server:~$ timedatectl timesync-status 
       Server: 185.125.190.58 (ntp.ubuntu.com)
Poll interval: 34min 8s (min: 32s; max 34min 8s)
         Leap: normal
      Version: 4
      Stratum: 2
    Reference: 4FF33C32
    Precision: 1us (-25)
Root distance: 884us (max: 5s)
       Offset: -44.347ms
        Delay: 194.843ms
       Jitter: 107.589ms
 Packet count: 13
    Frequency: +48.071ppm

```

Now let’s reload the configuration

```bash
server@server:~$ sudo systemctl restart systemd-timesyncd.service 

server@server:~$ timedatectl timesync-status 
       Server: 45.63.54.13 (0.us.pool.ntp.org)
Poll interval: 1min 4s (min: 32s; max 34min 8s)
         Leap: normal
      Version: 4
      Stratum: 2
    Reference: 42A225F4
    Precision: 1us (-26)
Root distance: 922us (max: 5s)
       Offset: -2.682ms
        Delay: 18.036ms
       Jitter: 0
 Packet count: 1
    Frequency: +27.114ppm
```

Now, NTP server is changed from [ntp.ubuntu.com](http://ntp.ubuntu.com) to 0.us.pool.ntp.org.