# Bridging and Bonding

### Bridging

There are example netplan yaml files in ubuntu at the path “/usr/share/doc/netplan/examples”. a

```bash
soeyehtet@ubuntu:~$ ls /usr/share/doc/netplan/examples/
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

There are three network interfaces “ens33, ens37, ens38” and we will not touch ens33 because it is a network interface we use for SSH  connection. Let’s copy the example file of bridge NETPLAN file to the path /etc/netplan 

```bash
soeyehtet@ubuntu:~$ sudo cp /usr/share/doc/netplan/examples/bridge.yaml /etc/netplan/99-mysettings.yaml
soeyehtet@ubuntu:~$ ls -l /etc/netplan/99-mysettings.yaml
-rw------- 1 root root 156 Feb 27 18:11 /etc/netplan/99-mysettings.yaml

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
       valid_lft 1491sec preferred_lft 1491sec
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
4: ens38: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0c:29:2b:b1:59 brd ff:ff:ff:ff:ff:ff
    altname enp2s6

```

Let’s modify the bridge connection in the following yaml file.

```bash
root@ubuntu:/etc/netplan# cat 99-mysettings.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens37:
      dhcp4: no
    ens38:
      dhcp4: no
  bridges:
    br0:
      dhcp4: yes
      interfaces:
        - ens37
        - ens38
root@ubuntu:/etc/netp
```

Let’s apply the modified yaml file.

```bash
root@ubuntu:/etc/netplan# netplan try
Do you want to keep these settings?

Press ENTER before the timeout to accept the new configuration

Changes will revert in 106 seconds
Configuration accepted.
```

Lets check the link status of ens37, ens38 and br0 and we can see that those links are UP status.

```bash
soeyehtet@ubuntu:/etc/netplan$ ip -c link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:2b:b1:45 brd ff:ff:ff:ff:ff:ff
    altname enp2s1
3: ens37: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0 state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:2b:b1:4f brd ff:ff:ff:ff:ff:ff
    altname enp2s5
4: ens38: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0 state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:2b:b1:59 brd ff:ff:ff:ff:ff:ff
    altname enp2s6
5: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 56:f8:28:25:94:6d brd ff:ff:ff:ff:ff:ff
```

br0 IP address is 192.168.20.129/24 and there are no IP address at ens37, ens38.

```bash
soeyehtet@ubuntu:/etc/netplan$ ip -c address
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
       valid_lft 1732sec preferred_lft 1732sec
    inet6 fe80::20c:29ff:fe2b:b145/64 scope link
       valid_lft forever preferred_lft forever
3: ens37: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0 state UP group default qlen 1000
    link/ether 00:0c:29:2b:b1:4f brd ff:ff:ff:ff:ff:ff
    altname enp2s5
4: ens38: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0 state UP group default qlen 1000
    link/ether 00:0c:29:2b:b1:59 brd ff:ff:ff:ff:ff:ff
    altname enp2s6
5: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 56:f8:28:25:94:6d brd ff:ff:ff:ff:ff:ff
    inet 192.168.20.129/24 metric 100 brd 192.168.20.255 scope global dynamic br0
       valid_lft 1731sec preferred_lft 1731sec
    inet6 fe80::54f8:28ff:fe25:946d/64 scope link
       valid_lft forever preferred_lft forever
```

Let’s see about the route for the new added bridge with the following command.

```bash
soeyehtet@ubuntu:/etc/netplan$ ip route
default via 192.168.211.2 dev ens33 proto dhcp src 192.168.211.129 metric 100
192.168.20.0/24 dev br0 proto kernel scope link src 192.168.20.129 metric 100
192.168.20.1 dev br0 proto dhcp scope link src 192.168.20.129 metric 100
192.168.211.0/24 dev ens33 proto kernel scope link src 192.168.211.129 metric 100
192.168.211.2 dev ens33 proto dhcp scope link src 192.168.211.129 metric 100
```

And we can see the necessary routes are also added for the br0 

### Bonding

Let’s clear the previously configured bridge br0 interface 

```bash
soeyehtet@ubuntu:/etc/netplan$ sudo ip link delete br0
```

Let’s copy the example file of bond NETPLAN file to the path /etc/netplan 

```bash
sudo cp bonding.yaml /etc/netplan/99-mysettings.yaml
```

We will configure active-backup mode for bond.

```bash
soeyehtet@ubuntu:/etc/netplan$ sudo cat 99-mysettings.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens37:
      dhcp4: no
    ens38:
      dhcp4: no
  bonds:
    bond0:
      dhcp4: yes
      interfaces:
        - ens37
        - ens38
      parameters:
        mode: active-backup
        primary: ens37
        mii-monitor-interval: 100
```

Let’s apply the bond netplan configuration.

```bash
soeyehtet@ubuntu:/etc/netplan$ sudo netplan try
bond0: reverting custom parameters for bridges and bonds is not supported

Please carefully review the configuration and use 'netplan apply' directly.
soeyehtet@ubuntu:/etc/netplan$ sudo netplan apply
```

Lets check the link status and we can see ens37, ens38 are acted as bond0

```bash
soeyehtet@ubuntu:/etc/netplan$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:2b:b1:45 brd ff:ff:ff:ff:ff:ff
    altname enp2s1
3: ens37: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master bond0 state UP mode DEFAULT group default qlen 1000
    link/ether 6a:0c:08:f2:a5:68 brd ff:ff:ff:ff:ff:ff permaddr 00:0c:29:2b:b1:4f
    altname enp2s5
4: ens38: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master bond0 state UP mode DEFAULT group default qlen 1000
    link/ether 6a:0c:08:f2:a5:68 brd ff:ff:ff:ff:ff:ff permaddr 00:0c:29:2b:b1:59
    altname enp2s6
6: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6a:0c:08:f2:a5:68 brd ff:ff:ff:ff:ff:ff
```

```bash
soeyehtet@ubuntu:/etc/netplan$ ip -c address
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
       valid_lft 1748sec preferred_lft 1748sec
    inet6 fe80::20c:29ff:fe2b:b145/64 scope link
       valid_lft forever preferred_lft forever
3: ens37: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master bond0 state UP group default qlen 1000
    link/ether 6a:0c:08:f2:a5:68 brd ff:ff:ff:ff:ff:ff permaddr 00:0c:29:2b:b1:4f
    altname enp2s5
4: ens38: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master bond0 state UP group default qlen 1000
    link/ether 6a:0c:08:f2:a5:68 brd ff:ff:ff:ff:ff:ff permaddr 00:0c:29:2b:b1:59
    altname enp2s6
6: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 6a:0c:08:f2:a5:68 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::680c:8ff:fef2:a568/64 scope link
       valid_lft forever preferred_lft forever
```

Let’s explore the content in the special directory 

```bash
soeyehtet@ubuntu:/etc/netplan$ cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v6.8.0-54-generic

Bonding Mode: fault-tolerance (active-backup)
Primary Slave: ens37 (primary_reselect always)
Currently Active Slave: ens37
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

Slave Interface: ens38
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 00:0c:29:2b:b1:59
Slave queue ID: 0

Slave Interface: ens37
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 00:0c:29:2b:b1:4f
Slave queue ID: 0
```

### Other bond mode in NETPLAN YAML File

if we want to set blanace-rr mode in bond mode.

```bash
network:
  version: 2
  renderer: networkd
  ethernets:
    ens37:
      dhcp4: no
    ens38:
      dhcp4: no
  bonds:
    bond0:
      dhcp4: yes
      interfaces:
        - ens37
        - ens38
      parameters:
        mode: balance-rr
```

Balance-XOR

```bash
network:
  version: 2
  renderer: networkd
  ethernets:
    ens37:
      dhcp4: no
    ens38:
      dhcp4: no
  bonds:
    bond0:
      dhcp4: yes
      interfaces:
        - ens37
        - ens38
      parameters:
        mode: balance-xor
```

Broadcast

```bash
network:
  version: 2
  renderer: networkd
  ethernets:
    ens37:
      dhcp4: no
    ens38:
      dhcp4: no
  bonds:
    bond0:
      dhcp4: yes
      interfaces:
        - ens37
        - ens38
      parameters:
        mode: broadcast
```