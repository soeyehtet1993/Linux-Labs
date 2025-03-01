# Packet Filtering

There are two ubuntu machines which are ubuntu server and ubuntu client. 

Let’s check the firewall status of server and client

At Server Side 

```bash
server@ubuntuserver:~$ sudo ufw status
[sudo] password for server:
Status: inactive
```

At Client Side 

```bash
client@ubuntuclient:~$ sudo ufw status
[sudo] password for client:
Status: inactive
```

### Allow SSH connection from any IP address

Before we continue we will add one rule to allow SSH connection in server and client side 

At Server Side (We allow port 22)

```bash
server@ubuntuserver:~$ sudo ufw allow 22
Rules updated
Rules updated (v6)
```

At Client Side (We allow ssh protocol)

```bash
client@ubuntuclient:~$ sudo ufw allow ssh
Rules updated
Rules updated (v6)
```

Enable the UFW in Server and Client 

At Server Side 

```bash
server@ubuntuserver:~$ sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
```

At Client Side

```bash
client@ubuntuclient:~$ sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
```

Let’s see the status of ufw

At Server Side 

```bash
server@ubuntuserver:~$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22                         ALLOW IN    Anywhere
22 (v6)                    ALLOW IN    Anywhere (v6)
```

At Client Side

```bash
client@ubuntuclient:~$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
22/tcp (v6)                ALLOW IN    Anywhere (v6)
```

<aside>
💡

We can see the default policy at server & client are denying all incoming traffic but we already add the rule to allow SSH connection at server & client.

</aside>

Now let’s check the SSH Connection Status 

At the server side

```bash
server@ubuntuserver:~$ ss -tn
State     Recv-Q     Send-Q                    Local Address:Port                    Peer Address:Port      Process
ESTAB     0          0              [::ffff:192.168.211.137]:22            [::ffff:192.168.211.1]:50763
```

At the client side

```bash
client@ubuntuclient:~$ ss -tn
State     Recv-Q     Send-Q                    Local Address:Port                    Peer Address:Port      Process
ESTAB     0          0              [::ffff:192.168.211.136]:22            [::ffff:192.168.211.1]:50659
```

Our Physical IP address 

```bash
Ethernet adapter VMware Network Adapter VMnet8:

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::3811:ad64:cdf4:8161%24
   IPv4 Address. . . . . . . . . . . : 192.168.211.1
```

We can see the SSH connections [from 192.168.211.1 to 192.168.211.137(server)] and [from 192.168.211.1 to 192.168.211.136(client)] have already been established. 

### Allow only SSH connection from 192.168.211.1 at server and client

Now we will add another rule 

Allow the SSH connection from 192.168.211.1 to any IP addresses of Server and Clients

At Server Side 

```bash
server@ubuntuserver:~$ sudo ufw allow from 192.168.211.1 to any port 22
Rule added
```

At Client Side

```bash
client@ubuntuclient:~$ sudo ufw allow from 192.168.211.1 to any port 22
Rule added
```

```bash
client@ubuntuclient:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    Anywhere
[ 2] 22                         ALLOW IN    192.168.211.1
[ 3] 22/tcp (v6)                ALLOW IN    Anywhere (v6)
```

Now there are three rules with number 1,2,3 and we need to know that the policies are executed in order. 

We will test whether client [192.168.211.136] can SSH to server [192.168.211.137] or not.

At the client side

```bash
client@ubuntuclient:~$ sudo ssh server@192.168.211.137
The authenticity of host '192.168.211.137 (192.168.211.137)' can't be established.
ED25519 key fingerprint is SHA256:6YjCjgqC96XKc874O/ilU0HSZ3CgBxk5fu4WYrM9xSg.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.211.137' (ED25519) to the list of known hosts.
server@192.168.211.137's password:
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-54-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Fri Feb 28 10:38:39 PM UTC 2025

  System load:  0.0                Processes:              223
  Usage of /:   10.7% of 47.93GB   Users logged in:        1
  Memory usage: 15%                IPv4 address for ens33: 192.168.211.137
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

131 updates can be applied immediately.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

server@ubuntuserver:~$
```

As we can see, client can ssh to server. 

So we will delete rule 1 which allow SSH connection from any IP address. 

At the server side

```bash
server@ubuntuserver:~$ sudo ufw delete 1
Deleting:
 allow 22
Proceed with operation (y|n)? y
Rule deleted

server@ubuntuserver:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    192.168.211.1
[ 2] 22 (v6)                    ALLOW IN    Anywhere (v6)
```

At the client side.

```bash
client@ubuntuclient:~$ sudo ufw delete 1
Deleting:
 allow 22/tcp
Proceed with operation (y|n)? y
Rule deleted

client@ubuntuclient:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    192.168.211.1
[ 2] 22/tcp (v6)                ALLOW IN    Anywhere (v6)
```

We will test again whether client [192.168.211.136] can SSH to server [192.168.211.137] or not.

```bash

client@ubuntuclient:~$ sudo ssh server@192.168.211.137
ssh: connect to host 192.168.211.137 port 22: Connection timed out

```

Now we can see ssh status is stuck when client log in to the server.

### Allow only incoming SSH connection from 192.168.211.0/24 network at server and client

At the server side

```bash
server@ubuntuserver:~$ sudo ufw allow in on ens33 from 192.168.211.0/24 to any port 22
Rule added

server@ubuntuserver:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    192.168.211.1
[ 2] 22 on ens33                ALLOW IN    192.168.211.0/24
[ 3] 22 (v6)                    ALLOW IN    Anywhere (v6)

server@ubuntuserver:~$ sudo ufw delete 1
Deleting:
 allow from 192.168.211.1 to any port 22
Proceed with operation (y|n)? y
Rule deleted
server@ubuntuserver:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22 on ens33                ALLOW IN    192.168.211.0/24
[ 2] 22 (v6)                    ALLOW IN    Anywhere (v6)
```

At the client side 

```bash
client@ubuntuclient:~$ sudo ufw allow in on ens33 from 192.168.211.0/24 to any port 22
[sudo] password for client:
Rule added
client@ubuntuclient:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    192.168.211.1
[ 2] 22 on ens33                ALLOW IN    192.168.211.0/24
[ 3] 22/tcp (v6)                ALLOW IN    Anywhere (v6)

client@ubuntuclient:~$ sudo ufw delete 1
Deleting:
 allow from 192.168.211.1 to any port 22
Proceed with operation (y|n)? y
Rule deleted
client@ubuntuclient:~$
```

Now client [192.168.211.136] ssh to server [192.168.211.137].

```bash
client@ubuntuclient:~$ ssh server@192.168.211.137
The authenticity of host '192.168.211.137 (192.168.211.137)' can't be established.
ED25519 key fingerprint is SHA256:6YjCjgqC96XKc874O/ilU0HSZ3CgBxk5fu4WYrM9xSg.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:1: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.211.137' (ED25519) to the list of known hosts.
server@192.168.211.137's password:
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-54-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Fri Feb 28 11:35:48 PM UTC 2025

  System load:  0.0                Processes:              226
  Usage of /:   10.7% of 47.93GB   Users logged in:        1
  Memory usage: 17%                IPv4 address for ens33: 192.168.211.137
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

131 updates can be applied immediately.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status

Last login: Fri Feb 28 22:38:39 2025 from 192.168.211.136
server@ubuntuserver:~$
```

### Allow only incoming SSH connection from 192.168.211.0/24 network at server but disallow SSH connection from client side

We add the another rules to server.

At the Server side

```bash
server@ubuntuserver:~$ sudo ufw deny from 192.168.211.136 ssh
[sudo] password for server:
ERROR: Wrong number of arguments
server@ubuntuserver:~$ sudo ufw deny from 192.168.211.136 port 22
Rule added
server@ubuntuserver:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22 on ens33                ALLOW IN    192.168.211.0/24
[ 2] Anywhere                   DENY IN     192.168.211.136 22
[ 3] 22 (v6)                    ALLOW IN    Anywhere (v6)
```

The rule 1 number allow all incoming connection from 192.168.211.0 to port 22 of server. Therefore Client can still SSH to Server.

Delete the rule 2 and re add the rule as rule 1.

```bash
server@ubuntuserver:~$ sudo ufw delete 2
Deleting:
 deny from 192.168.211.136 port 22
Proceed with operation (y|n)? y
Rule deleted
server@ubuntuserver:~$ sudo ufw insert 1 deny from 192.168.211.136 port 22
Rule inserted
server@ubuntuserver:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] Anywhere                   DENY IN     192.168.211.136 22
[ 2] 22 on ens33                ALLOW IN    192.168.211.0/24
[ 3] 22 (v6)                    ALLOW IN    Anywhere (v6)
```

However, the SSH Connection can still established from Client to Server because in our rule, we only deny from 192.168.211.136:22 connection. At rule [1], to is still “Anywhere”

```bash
client@ubuntuclient:~$ ssh server@192.168.211.137
server@192.168.211.137's password:
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-54-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Fri Feb 28 11:48:27 PM UTC 2025

  System load:  0.05               Processes:              225
  Usage of /:   10.7% of 47.93GB   Users logged in:        1
  Memory usage: 15%                IPv4 address for ens33: 192.168.211.137
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

131 updates can be applied immediately.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status

Last login: Fri Feb 28 23:35:48 2025 from 192.168.211.136
server@ubuntuserver:~$
```

Let’s fix it by denying the connection to 22 port of SSH from Client.

```bash
server@ubuntuserver:~$ sudo ufw insert 1 deny from 192.168.211.136 to any port 22
[sudo] password for server:
Rule inserted

server@ubuntuserver:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22                         DENY IN     192.168.211.136
[ 2] Anywhere                   DENY IN     192.168.211.136 22
```

```bash
client@ubuntuclient:~$ ssh server@192.168.211.137
ssh: connect to host 192.168.211.137 port 22: Connection timed out
```

Now Client cannot SSH to server. 

Lets clear the UFW rules at server and client.

At Server Side

```bash
server@ubuntuserver:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22                         ALLOW       192.168.211.0/24
```

At Client Side

```bash
client@ubuntuclient:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22 on ens33                ALLOW       192.168.211.0/24
```

### Allow only incoming SSH connection from 192.168.211.0/24 network at server but disallow SSH connection from client side

Although all incoming traffic is blocked in default, but icmp traffic is allowed in default for network diagnostic purpose. 

 We can check here.

```bash
server@ubuntuserver:~$ sudo cat /etc/ufw/before.rules | grep 'icmp'
# ok icmp codes for INPUT
-A ufw-before-input -p icmp --icmp-type destination-unreachable -j ACCEPT
-A ufw-before-input -p icmp --icmp-type time-exceeded -j ACCEPT
-A ufw-before-input -p icmp --icmp-type parameter-problem -j ACCEPT
-A ufw-before-input -p icmp --icmp-type echo-request -j ACCEPT
# ok icmp code for FORWARD
-A ufw-before-forward -p icmp --icmp-type destination-unreachable -j ACCEPT
-A ufw-before-forward -p icmp --icmp-type time-exceeded -j ACCEPT
-A ufw-before-forward -p icmp --icmp-type parameter-problem -j ACCEPT
-A ufw-before-forward -p icmp --icmp-type echo-request -j ACCEPT
```

ICMP Connection Test

From Server to Client 

```bash
server@ubuntuserver:~$ ping client -c 4
PING client (192.168.211.136) 56(84) bytes of data.
64 bytes from client (192.168.211.136): icmp_seq=1 ttl=64 time=0.021 ms
64 bytes from client (192.168.211.136): icmp_seq=2 ttl=64 time=0.040 ms
64 bytes from client (192.168.211.136): icmp_seq=3 ttl=64 time=0.043 ms
64 bytes from client (192.168.211.136): icmp_seq=4 ttl=64 time=0.042 ms

--- client ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3069ms
rtt min/avg/max/mdev = 0.021/0.036/0.043/0.009 ms
```

From Client to Server

```bash
client@ubuntuclient:/etc$ ping server -c 4
PING server (192.168.211.137) 56(84) bytes of data.
64 bytes from server (192.168.211.137): icmp_seq=1 ttl=64 time=0.356 ms
64 bytes from server (192.168.211.137): icmp_seq=2 ttl=64 time=0.344 ms
64 bytes from server (192.168.211.137): icmp_seq=3 ttl=64 time=0.335 ms
64 bytes from server (192.168.211.137): icmp_seq=4 ttl=64 time=0.318 ms

--- server ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3074ms
rtt min/avg/max/mdev = 0.318/0.338/0.356/0.013 ms
client@ubuntuclient:/etc$
```

Now lets block the ICMP Traffic from Client to Server. This is because ICMP traffic is enabled in /etc/ufw/before.rules

At the client side

```bash
client@ubuntuclient:/etc$ sudo ufw deny out on ens33 from 192.168.211.136 to 192.168.211.137 proto icmp
ERROR: Unsupported protocol 'icmp'
```

Instead of that we will block outgoing traffic from client to server

At the client side

```bash
client@ubuntuclient:/etc$ sudo ufw deny out on ens33 from 192.168.211.136 to 192.168.211.137
Rule added
```

ICMP Connection Test

At the server side

```bash
server@ubuntuserver:~$ ping client -c 4
PING client (192.168.211.136) 56(84) bytes of data.
64 bytes from client (192.168.211.136): icmp_seq=1 ttl=64 time=0.026 ms
64 bytes from client (192.168.211.136): icmp_seq=2 ttl=64 time=0.040 ms
64 bytes from client (192.168.211.136): icmp_seq=3 ttl=64 time=0.040 ms
64 bytes from client (192.168.211.136): icmp_seq=4 ttl=64 time=0.038 ms

--- client ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3070ms
rtt min/avg/max/mdev = 0.026/0.036/0.040/0.005 ms
```

At the client side

```bash
client@ubuntuclient:/etc$ ping server -c 4
PING server (192.168.211.137) 56(84) bytes of data.

--- server ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3089ms
```

As we can see, client cannot ping to server. Lets block at the server side as well.

At the server side 

```bash
server@ubuntuserver:~$ sudo ufw deny out on ens33 to 192.168.211.137
Rule added

server@ubuntuserver:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    192.168.211.0/24
[ 2] 192.168.211.136            DENY OUT    Anywhere on ens33          (out)

server@ubuntuserver:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    192.168.211.0/24
[ 2] 192.168.211.136            DENY OUT    Anywhere on ens33          (out)
```

ICMP Connection Test

At the server side

```bash
server@ubuntuserver:~$ ping client -c 4
PING client (192.168.211.136) 56(84) bytes of data.

--- client ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3082ms
```

At the client side

```bash
client@ubuntuclient:/etc$ ping server -c 4
PING server (192.168.211.137) 56(84) bytes of data.

--- server ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3075ms
```

If we want to block with protocol, we can also do like this 

```bash
client@ubuntuclient:/etc$ sudo ufw deny out on ens33 to 192.168.211.137 proto udp
Rule added
client@ubuntuclient:/etc$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22 on ens33                ALLOW IN    192.168.211.0/24
[ 2] 192.168.211.137            DENY OUT    Anywhere on ens33          (out)
[ 3] 192.168.211.137/udp        DENY OUT    Anywhere on ens33          (out)
```