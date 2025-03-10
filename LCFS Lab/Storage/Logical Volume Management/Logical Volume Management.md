# Logical Volume Management

In this lab, we will demonstrate how to manage logical volume in ubuntu OS.

```bash
client@ubuntuclient:~$ lsblk /dev/sd*
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0  100G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    2G  0 part /boot
└─sda3                      8:3    0   98G  0 part
  └─ubuntu--vg-ubuntu--lv 252:0    0   49G  0 lvm  /
sda1                        8:1    0    1M  0 part
sda2                        8:2    0    2G  0 part /boot
sda3                        8:3    0   98G  0 part
└─ubuntu--vg-ubuntu--lv   252:0    0   49G  0 lvm  /
sdb                         8:16   0   15G  0 disk
sdc                         8:32   0    5G  0 disk
```

In our virtual machine, there are three virtual storage device which are sda, sdb and sdb. There are three partitions in sda which are sda1, sda2 , sda3. In this lab, we will use sdb which has 15 GB and sdc which has 5GB.. 

Step 1: Install lvm2 package 

```bash
client@ubuntuclient:~$ sudo apt-get install -y lvm2
[sudo] password for client:
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  dmeventd dmsetup libdevmapper-event1.02.1 libdevmapper1.02.1 liblvm2cmd2.03
The following packages will be upgraded:
  dmeventd dmsetup libdevmapper-event1.02.1 libdevmapper1.02.1 liblvm2cmd2.03 lvm2
6 upgraded, 0 newly installed, 0 to remove and 140 not upgraded.
Need to get 2,252 kB of archives.
After this operation, 0 B of additional disk space will be used.
Get:1 http://us.archive.ubuntu.com/ubuntu noble-updates/main amd64 libdevmapper1.02.1 amd64 2:1.02.185-3ubuntu3.2 [139 kB]
Get:2 http://us.archive.ubuntu.com/ubuntu noble-updates/main amd64 dmsetup amd64 2:1.02.185-3ubuntu3.2 [79.2 kB]
Get:3 http://us.archive.ubuntu.com/ubuntu noble-updates/main amd64 libdevmapper-event1.02.1 amd64 2:1.02.185-3ubuntu3.2 [12.6 kB]
Get:4 http://us.archive.ubuntu.com/ubuntu noble-updates/main amd64 liblvm2cmd2.03 amd64 2.03.16-3ubuntu3.2 [797 kB]
Get:5 http://us.archive.ubuntu.com/ubuntu noble-updates/main amd64 dmeventd amd64 2:1.02.185-3ubuntu3.2 [38.0 kB]
Get:6 http://us.archive.ubuntu.com/ubuntu noble-updates/main amd64 lvm2 amd64 2.03.16-3ubuntu3.2 [1,186 kB]
Fetched 2,252 kB in 1s (2,003 kB/s)
(Reading database ... 122005 files and directories currently installed.)
Preparing to unpack .../0-libdevmapper1.02.1_2%3a1.02.185-3ubuntu3.2_amd64.deb ...
Unpacking libdevmapper1.02.1:amd64 (2:1.02.185-3ubuntu3.2) over (2:1.02.185-3ubuntu3) ...
Preparing to unpack .../1-dmsetup_2%3a1.02.185-3ubuntu3.2_amd64.deb ...
Unpacking dmsetup (2:1.02.185-3ubuntu3.2) over (2:1.02.185-3ubuntu3) ...
Preparing to unpack .../2-libdevmapper-event1.02.1_2%3a1.02.185-3ubuntu3.2_amd64.deb ...
Unpacking libdevmapper-event1.02.1:amd64 (2:1.02.185-3ubuntu3.2) over (2:1.02.185-3ubuntu3) ...
Preparing to unpack .../3-liblvm2cmd2.03_2.03.16-3ubuntu3.2_amd64.deb ...
Unpacking liblvm2cmd2.03:amd64 (2.03.16-3ubuntu3.2) over (2.03.16-3ubuntu3) ...
Preparing to unpack .../4-dmeventd_2%3a1.02.185-3ubuntu3.2_amd64.deb ...
Unpacking dmeventd (2:1.02.185-3ubuntu3.2) over (2:1.02.185-3ubuntu3) ...
Preparing to unpack .../5-lvm2_2.03.16-3ubuntu3.2_amd64.deb ...
Unpacking lvm2 (2.03.16-3ubuntu3.2) over (2.03.16-3ubuntu3) ...
Setting up libdevmapper1.02.1:amd64 (2:1.02.185-3ubuntu3.2) ...
Setting up dmsetup (2:1.02.185-3ubuntu3.2) ...
Setting up libdevmapper-event1.02.1:amd64 (2:1.02.185-3ubuntu3.2) ...
Setting up liblvm2cmd2.03:amd64 (2.03.16-3ubuntu3.2) ...
Setting up dmeventd (2:1.02.185-3ubuntu3.2) ...
dm-event.service is a disabled or a static unit not running, not starting it.
Setting up lvm2 (2.03.16-3ubuntu3.2) ...
Processing triggers for initramfs-tools (0.142ubuntu25.1) ...
update-initramfs: Generating /boot/initrd.img-6.8.0-54-generic
Processing triggers for libc-bin (2.39-0ubuntu8.4) ...
Processing triggers for man-db (2.12.0-4build2) ...
Scanning processes...
Scanning candidates...
Scanning linux images...

Running kernel seems to be up-to-date.

Restarting services...
 systemctl restart multipathd.service udisks2.service

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
```

There are four terms related to LVM which are 

1. PV (Physical Volume) → Can be entire Disk or Partition 
2. VG (Volume Group)
3. LV (Logical Volume)
4. PE (Physical Extent)

```bash
client@ubuntuclient:~$ sudo lvmdiskscan
[sudo] password for client:
  /dev/loop0 [     <63.70 MiB]
  /dev/loop1 [     <63.75 MiB]
  /dev/loop2 [      70.50 MiB]
  /dev/sda2  [       2.00 GiB]
  /dev/loop3 [     <73.72 MiB]
  /dev/sda3  [     <98.00 GiB] LVM physical volume
  /dev/loop4 [     <44.44 MiB]
  /dev/sdb   [      15.00 GiB]
  /dev/sdc   [       5.00 GiB]
  2 disks
  6 partitions
  0 LVM physical volume whole disks
  1 LVM physical volume
```

/dev/sda3 is already used as LVM Physical volume and we will use /dev/sdb and /dev/sdc in this lab.

Step 2: Create the LVM Physical volume 

```bash
client@ubuntuclient:~$ sudo pvcreate /dev/sdb /dev/sdc
[sudo] password for client:
  Physical volume "/dev/sdb" successfully created.
  Physical volume "/dev/sdc" successfully created.
```

Now we can see “/dev/sdb” and “/dev/sdc” are used as the LVM physical volume.

```bash
client@ubuntuclient:~$ sudo lvmdiskscan
  /dev/loop0 [     <63.70 MiB]
  /dev/loop1 [     <63.75 MiB]
  /dev/loop2 [      70.50 MiB]
  /dev/sda2  [       2.00 GiB]
  /dev/loop3 [     <73.72 MiB]
  /dev/sda3  [     <98.00 GiB] LVM physical volume
  /dev/loop4 [     <44.44 MiB]
  /dev/sdb   [      15.00 GiB] LVM physical volume
  /dev/sdc   [       5.00 GiB] LVM physical volume
  0 disks
  6 partitions
  2 LVM physical volume whole disks
  1 LVM physical volume
```

We can also use another command to check the physical volumes. 

```bash
client@ubuntuclient:~$ sudo pvs
  PV         VG        Fmt  Attr PSize   PFree
  /dev/sda3  ubuntu-vg lvm2 a--  <98.00g 49.00g
  /dev/sdb             lvm2 ---   15.00g 15.00g
  /dev/sdc             lvm2 ---    5.00g  5.00g
```

Step 3: Create the volume group

```bash
client@ubuntuclient:~$ sudo vgcreate my_volume /dev/sdb /dev/sdc
[sudo] password for client:
  Volume group "my_volume" successfully created
```

We can also check the volume groups by typing “sudo vgs”

```bash
client@ubuntuclient:~$ sudo vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  my_volume   2   0   0 wz--n-  19.99g 19.99g
  ubuntu-vg   1   1   0 wz--n- <98.00g 49.00g
```

my_volume is logical volume that we create and the total size is 19.99GB (15 GB (sdb) + 5GB (sdc)) and ubuntu_vg is the logical volume group that is created by default when we install the ubuntu os.

We can also resize the volume group by removing and adding the disk or partition to the volume group. 

We will now remove /dev/sdc from my_volume and the size of my_volume will be reduced from 20G to 15G.

```bash
client@ubuntuclient:~$ sudo vgreduce my_volume /dev/sdc
  Removed "/dev/sdc" from volume group "my_volume"
```

```bash
client@ubuntuclient:~$ sudo vgs my_volume
  VG        #PV #LV #SN Attr   VSize   VFree
  my_volume   1   0   0 wz--n- <15.00g <15.00g
```

Now the size of my_volume is reduced from 20G to 15G. Let’s readd back to /dev/sdc to my_volume.

```bash
client@ubuntuclient:~$ sudo vgextend my_volume /dev/sdc
  Volume group "my_volume" successfully extended
client@ubuntuclient:~$ sudo vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  my_volume   2   0   0 wz--n-  19.99g 19.99g
  ubuntu-vg   1   1   0 wz--n- <98.00g 49.00g
```

Step 4: Partition the volume group by creating the logical volume. 

We will partition with the name “partition1” and assign the size 2GB to that partition.

```bash
client@ubuntuclient:~$ sudo lvcreate --size 2G --name partition1 my_volume
  Logical volume "partition1" created.
  
  client@ubuntuclient:~$ sudo vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  my_volume   2   1   0 wz--n-  19.99g 17.99g
  ubuntu-vg   1   1   0 wz--n- <98.00g 49.00g
```

If we carefully look, the number of LV in my_volume is now 1 and the free size of the disk now reduced from 19.99GB to 17.99GB.

We will now create the second partition in my_volume.

```bash
client@ubuntuclient:~$ sudo lvcreate --size 6G --name partition2 my_volume
  Logical volume "partition2" created.
client@ubuntuclient:~$ sudo vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  my_volume   2   2   0 wz--n-  19.99g 11.99g
  ubuntu-vg   1   1   0 wz--n- <98.00g 49.00g
```

We can now also check the logical volume by command “sudo lvs”.

```bash
client@ubuntuclient:~$ sudo lvs
  LV         VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  partition1 my_volume -wi-a-----   2.00g
  partition2 my_volume -wi-a-----   6.00g
  ubuntu-lv  ubuntu-vg -wi-ao---- <49.00g
```

We will now create the third partition in my_volume and assign 10G that that partition.

```bash
client@ubuntuclient:~$ sudo lvcreate --size 10G --name partition3 my_volume
  Logical volume "partition3" created.
client@ubuntuclient:~$ sudo vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  my_volume   2   3   0 wz--n-  19.99g  1.99g
  ubuntu-vg   1   1   0 wz--n- <98.00g 49.00g
```

Now, the available size of my_volume is only 1.99GB. We will instruct partition1 to use 100% of my_volume remaining size like this. 

```bash
client@ubuntuclient:~$ sudo lvresize --extents 100%VG my_volume/partition1
  Reducing 100%VG to remaining free space 3.99 GiB in VG.
  Size of logical volume my_volume/partition1 changed from 2.00 GiB (512 extents) to 3.99 GiB (1022 extents).
  Logical volume my_volume/partition1 successfully resized.
client@ubuntuclient:~$ sudo vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  my_volume   2   3   0 wz--n-  19.99g     0
  ubuntu-vg   1   1   0 wz--n- <98.00g 49.00g
client@ubuntuclient:~$
```

```bash
client@ubuntuclient:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0                       7:0    0 63.7M  1 loop /snap/core20/2434
loop1                       7:1    0 63.7M  1 loop /snap/core20/2496
loop2                       7:2    0 70.5M  1 loop /snap/powershell/281
loop3                       7:3    0 73.7M  1 loop /snap/powershell/283
loop4                       7:4    0 44.4M  1 loop /snap/snapd/23545
sda                         8:0    0  100G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    2G  0 part /boot
└─sda3                      8:3    0   98G  0 part
  └─ubuntu--vg-ubuntu--lv 252:0    0   49G  0 lvm  /
sdb                         8:16   0   15G  0 disk
├─my_volume-partition1    252:1    0    4G  0 lvm
├─my_volume-partition2    252:2    0    6G  0 lvm
└─my_volume-partition3    252:3    0   10G  0 lvm
sdc                         8:32   0    5G  0 disk
├─my_volume-partition1    252:1    0    4G  0 lvm
└─my_volume-partition3    252:3    0   10G  0 lvm
```

Step 5: Configuring the file system to logical volume. 

The path for the logical volume can be found by following syntax.

“/dev/name_of_volume_group/name_of_logical_volume”

```bash
client@ubuntuclient:/dev/my_volume$ pwd
/dev/my_volume

client@ubuntuclient:/dev/my_volume$ ls
partition1  partition2  partition3
```

We can find the three logical volumes at the path “/dev/my_volume”. We can also check the detail of each LV with the command “sudo lvdisplay”

```bash
client@ubuntuclient:/dev/my_volume$ sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/my_volume/partition1
  LV Name                partition1
  VG Name                my_volume
  LV UUID                dGYcn8-jQdP-lR9e-V1Vo-yMwH-eOIC-N9G3d8
  LV Write Access        read/write
  LV Creation host, time ubuntuclient, 2025-03-10 06:58:22 +0000
  LV Status              available
  # open                 0
  LV Size                3.99 GiB
  Current LE             1022
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:1

  --- Logical volume ---
  LV Path                /dev/my_volume/partition2
  LV Name                partition2
  VG Name                my_volume
  LV UUID                Xgfvdk-8qeR-YJt3-nmqb-D7kS-G5mN-DKYuH3
  LV Write Access        read/write
  LV Creation host, time ubuntuclient, 2025-03-10 07:00:44 +0000
  LV Status              available
  # open                 0
  LV Size                6.00 GiB
  Current LE             1536
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:2

  --- Logical volume ---
  LV Path                /dev/my_volume/partition3
  LV Name                partition3
  VG Name                my_volume
  LV UUID                7WUV72-r2rl-bEsQ-CBA5-VyUI-NCaE-06i8dg
  LV Write Access        read/write
  LV Creation host, time ubuntuclient, 2025-03-10 07:03:19 +0000
  LV Status              available
  # open                 0
  LV Size                10.00 GiB
  Current LE             2560
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:3

  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                HGuUyw-h7aP-iQt5-nJd4-b4Y3-YRGy-2mZKZu
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2025-01-30 19:48:53 +0000
  LV Status              available
  # open                 1
  LV Size                <49.00 GiB
  Current LE             12543
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:0
```

Now lets set the ext4 file system for partition1

```bash
client@ubuntuclient:/dev/my_volume$ sudo lsblk -f /dev/my_volume/partition1
NAME                 FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
my_volume-partition1 ext4   1.0         f7c927ed-a86b-4aed-bb11-19c2f75fe410
```

If we want to resize the partition1, we need to be careful now

```bash
client@ubuntuclient:sudo lvresize --size 3G my_volume/partition1
```

If we use this command, it will only resize the LV from 2GB to 3GB but the ext4 file system would still use 2GB and we need to use the following command to resize both the LV and ext4 file system.

```bash
client@ubuntuclient:sudo lvresize --resizefs --size 3G my_volume/partition1
```

Step 6: Mount the logical volume “partition1”

```bash
client@ubuntuclient:/mnt$ sudo lsblk -f /dev/my_volume/partition1
NAME                 FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
my_volume-partition1 ext4   1.0         f7c927ed-a86b-4aed-bb11-19c2f75fe410    3.6G     0% /mnt/lv1
```

And we can also persistently in fstab.

```bash
client@ubuntuclient:~$ cat /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/ubuntu-vg/ubuntu-lv during curtin installation
/dev/disk/by-id/dm-uuid-LVM-LCxzQ7fhVbEbSW14gX0e89UBFKfAUkvXHGuUywh7aPiQt5nJd4b4Y3YRGy2mZKZu / ext4 defaults 0 1
# /boot was on /dev/sda2 during curtin installation
/dev/disk/by-uuid/bb6ccfce-7c9e-4bfd-be93-4b2ed1e16a2b /boot ext4 defaults 0 1
/swap.img       none    swap    sw      0       0
server:/mnt/sdb2        /nfs/sharedrive nfs     defaults 0      0
/dev/my_volume/partition1 /mnt/lv1/ ext4 defaults 0 2
```

Let’s reboot and check block device.

```bash
client@ubuntuclient:~$ sudo lsblk -f /dev/my_volume/partition1
NAME                 FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
my_volume-partition1 ext4   1.0         f7c927ed-a86b-4aed-bb11-19c2f75fe410    3.6G     0% /mnt/lv1
```