# IPV4 Netowrking

### Assigning the IP Address

Currently there are two physical network interface in ubuntu server which are “ens33” and “ens37” and we will assign IP address in ens37.

```bash
soeyehtet@ubuntu:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:2b:b1:45 brd ff:ff:ff:ff:ff:ff
    altname enp2s1
    inet 192.168.211.129/24 metric 100 brd 192.168.211.255 scope global dynamic ens33
       valid_lft 1757sec preferred_lft 1757sec
    inet6 fe80::20c:29ff:fe2b:b145/64 scope link
       valid_lft forever preferred_lft forever
3: ens37: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0c:29:2b:b1:4f brd ff:ff:ff:ff:ff:ff
    altname enp2s5
```

In net plan configuration file which is “50-cloud-init.yaml”, only the configuration of ens33 is described. We will not touch the default file, and we will create another file which will be “99-mysetting.yaml”

```bash
soeyehtet@ubuntu:~$ sudo cat /etc/netplan/50-cloud-init.yaml
[sudo] password for soeyehtet:
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        ens33:
            dhcp4: true
    version: 2
```

OR 

```bash
soeyehtet@ubuntu:~$ sudo netplan get
network:
  version: 2
  ethernets:
    ens33:
      dhcp4: true
```

Lets create the new netplan file with YAML format with the name 99-mysetting.yaml then assign IP address at ens37 interface.

```bash
soeyehtet@ubuntu:~$ sudo cat /etc/netplan/99-mysettings.yaml
network:
    ethernets:
        ens33:
            dhcp4: true
        ens37:
            dhcp4: false
            dhcp6: false
            addresses:
              - 192.168.211.222/24
              - fe80::921b:eff:fe3d:abcd/64
    version: 2
```

After creating the new netplan file and apply the newly created file.

```bash
root@ubuntu:/etc/netplan# sudo netplan try

** (process:12814): WARNING **: 18:39:22.947: Permissions for /etc/netplan/99-mysettings.yaml are too open. Netplan configuration should NOT be accessible by others.

** (generate:12815): WARNING **: 18:39:22.951: Permissions for /etc/netplan/99-mysettings.yaml are too open. Netplan configuration should NOT be accessible by others.

** (process:12814): WARNING **: 18:39:23.170: Permissions for /etc/netplan/99-mysettings.yaml are too open. Netplan configuration should NOT be accessible by others.

** (process:12814): WARNING **: 18:39:23.261: Permissions for /etc/netplan/99-mysettings.yaml are too open. Netplan configuration should NOT be accessible by others.
Do you want to keep these settings?

Press ENTER before the timeout to accept the new configuration

Changes will revert in  97 seconds
Configuration accepted.
root@ubuntu:/etc/netplan#

```

There is a some permission warning message and let’s check the permission of that file.

```bash
root@ubuntu:/etc/netplan# ls -l
total 8
-rw------- 1 root root 390 Jan 30 20:01 50-cloud-init.yaml
-rw-r--r-- 1 root root 245 Feb 22 20:06 99-mysettings.yaml
root@ubuntu:/etc/netplan# sudo chmod 600 99-mysettings.yaml

root@ubuntu:/etc/netplan# ls -l
total 8
-rw------- 1 root root 390 Jan 30 20:01 50-cloud-init.yaml
-rw------- 1 root root 480 Feb 26 18:52 99-mysettings.yaml
```

After we only give read/write access for the user and and there is not permission warning message when we apply the netplan file.

```bash
root@ubuntu:/etc/netplan# sudo netplan try
Do you want to keep these settings?

Press ENTER before the timeout to accept the new configuration

Changes will revert in 113 seconds
Configuration accepted.
root@ubuntu:/etc/netplan#
```

We will now check the current plan configuration that the system use.

```bash
root@ubuntu:/etc/netplan# sudo netplan get
network:
  version: 2
  ethernets:
    ens33:
      dhcp4: true
    ens37:
      addresses:
      - "192.168.211.222/24"
      - "fe80::921b:eff:fe3d:abcd/64"
      dhcp4: false
      dhcp6: false
root@ubuntu:/etc/netplan#
```

Now let’s check the ip address of ens37.

```bash
root@ubuntu:/etc/netplan# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:2b:b1:45 brd ff:ff:ff:ff:ff:ff
    altname enp2s1
    inet 192.168.211.129/24 metric 100 brd 192.168.211.255 scope global dynamic ens33
       valid_lft 1761sec preferred_lft 1761sec
    inet6 fe80::20c:29ff:fe2b:b145/64 scope link
       valid_lft forever preferred_lft forever
3: ens37: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:2b:b1:4f brd ff:ff:ff:ff:ff:ff
    altname enp2s5
    inet 192.168.211.222/24 brd 192.168.211.255 scope global ens37
       valid_lft forever preferred_lft forever
    inet6 fe80::921b:eff:fe3d:abcd/64 scope link
       valid_lft forever preferred_lft forever
    inet6 fe80::20c:29ff:fe2b:b14f/64 scope link
       valid_lft forever preferred_lft forever
```

### Assigning the DNS Server IP address

Let’s assign nameserver in ens37.

```bash
root@ubuntu:/etc/netplan# cat 99-mysettings.yaml
network:
    ethernets:
        ens33:
            dhcp4: true
        ens37:
            dhcp4: false
            dhcp6: false
            addresses:
              - 192.168.211.222/24
              - fe80::921b:eff:fe3d:abcd/64
            nameservers:
              addresses:
                - 8.8.8.8
    version: 2
```

8.8.8.8 is now assigned as the DNS Server IP address for ens37 interface.

```bash
root@ubuntu:/etc/netplan# resolvectl status
Global
         Protocols: -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
  resolv.conf mode: stub

Link 2 (ens33)
    Current Scopes: DNS
         Protocols: +DefaultRoute -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
       DNS Servers: 192.168.211.2
        DNS Domain: localdomain

Link 3 (ens37)
    Current Scopes: DNS
         Protocols: +DefaultRoute -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
       DNS Servers: 8.8.8.8
```

### Assigning the Default Route

Now let’s add the default route for ens37.

```bash
root@ubuntu:/etc/netplan# cat 99-mysettings.yaml
network:
    ethernets:
        ens33:
            dhcp4: true
        ens37:
            dhcp4: false
            dhcp6: false
            addresses:
              - 192.168.211.222/24
              - fe80::921b:eff:fe3d:abcd/64
            nameservers:
              addresses:
                - 8.8.8.8
            routes:
              - to : 192.168.0.0/24
                via : 192.168.211.2
              - to : default
                via : 192.168.211.2

    version: 2
```

```bash
root@ubuntu:/etc/netplan# ip route
default via 192.168.211.2 dev ens37 proto static
default via 192.168.211.2 dev ens33 proto dhcp src 192.168.211.129 metric 100
192.168.0.0/24 via 192.168.211.2 dev ens37 proto static
192.168.211.0/24 dev ens37 proto kernel scope link src 192.168.211.222
192.168.211.0/24 dev ens33 proto kernel scope link src 192.168.211.129 metric 100
192.168.211.2 dev ens33 proto dhcp scope link src 192.168.211.129 metric 100
```

We can also add DNS Server in different way  at /etc/systemd/resolved.conf file.

```bash
root@ubuntu:/etc/systemd# cat /etc/systemd/resolved.conf
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it under the
#  terms of the GNU Lesser General Public License as published by the Free
#  Software Foundation; either version 2.1 of the License, or (at your option)
#  any later version.
#
# Entries in this file show the compile time defaults. Local configuration
# should be created by either modifying this file (or a copy of it placed in
# /etc/ if the original file is shipped in /usr/), or by creating "drop-ins" in
# the /etc/systemd/resolved.conf.d/ directory. The latter is generally
# recommended. Defaults can be restored by simply deleting the main
# configuration file and all drop-ins located in /etc/.
#
# Use 'systemd-analyze cat-config systemd/resolved.conf' to display the full config.
#
# See resolved.conf(5) for details.

[Resolve]
# Some examples of DNS servers which may be used for DNS= and FallbackDNS=:
# Cloudflare: 1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 2606:4700:4700::1001#cloudflare-dns.com
# Google:     8.8.8.8#dns.google 8.8.4.4#dns.google 2001:4860:4860::8888#dns.google 2001:4860:4860::8844#dns.google
# Quad9:      9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
DNS=1.1.1.1 9.9.9.9
#DNS=
#FallbackDNS=
#Domains=
#DNSSEC=no
#DNSOverTLS=no
#MulticastDNS=no
#LLMNR=no
#Cache=no-negative
#CacheFromLocalhost=no
#DNSStubListener=yes
#DNSStubListenerExtra=
#ReadEtcHosts=yes
#ResolveUnicastSingleLabel=no
#StaleRetentionSec=0

root@ubuntu:/etc/systemd# systemctl restart systemd-resolved.service
```

Now lets check the DNS IP addresses information.

```bash
root@ubuntu:/etc/systemd# resolvectl dns
Global: 1.1.1.1 9.9.9.9
Link 2 (ens33): 192.168.211.2
Link 3 (ens37): 8.8.8.8
root@ubuntu:/etc/systemd#
```

Adding IP address in “/etc/hosts/” file.

```bash
root@ubuntu:/etc# cat /etc/hosts
127.0.0.1 localhost
127.0.1.1 ubuntu
192.168.5.157 pc

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
root@ubuntu:/etc#
```

```bash
root@ubuntu:/etc/netplan# ping pc -c 3
PING pc (192.168.5.157) 56(84) bytes of data.
64 bytes from pc (192.168.5.157): icmp_seq=1 ttl=128 time=0.697 ms
64 bytes from pc (192.168.5.157): icmp_seq=2 ttl=128 time=0.542 ms
64 bytes from pc (192.168.5.157): icmp_seq=3 ttl=128 time=0.552 ms

--- pc ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2069ms
rtt min/avg/max/mdev = 0.542/0.597/0.697/0.070 ms
root@ubuntu:/etc/netplan#
```

There are some example of netplan files we can reference at the directory “usr/share/doc/netplan/examples”

```bash
root@ubuntu:/usr/share/doc/netplan/examples# ls
bonding_router.yaml               modem.yaml                                  vlan.yaml
bonding.yaml                      network_manager.yaml                        vrf.yaml
bridge_vlan.yaml                  offload.yaml                                vxlan.yaml
bridge.yaml                       openvswitch.yaml                            windows_dhcp_server.yaml
dhcp_wired8021x.yaml              route_metric.yaml                           wireguard.yaml
dhcp.yaml                         source_routing.yaml                         wireless_adhoc.yaml
direct_connect_gateway_ipv6.yaml  sriov_vlan.yaml                             wireless_wpa3.yaml
direct_connect_gateway.yaml       sriov.yaml                                  wireless.yaml
dummy-devices.yaml                static_multiaddress.yaml                    wpa3_enterprise.yaml
infiniband.yaml                   static_singlenic_multiip_multigateway.yaml  wpa_enterprise.yaml
ipv6_tunnel.yaml                  static.yaml
loopback_interface.yaml           virtual-ethernet.yaml
```