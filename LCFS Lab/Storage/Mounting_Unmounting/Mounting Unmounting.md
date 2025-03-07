# Mounting/Unmounting

### Mounting

Mounting is attaching or plugging in a file system to one of our directories. 

```bash
server@ubuntuserver:~$ sudo lsblk /dev/sdb
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
sdb      8:16   0  20G  0 disk
├─sdb1   8:17   0   5G  0 part
├─sdb2   8:18   0   5G  0 part
├─sdb3   8:19   0   5G  0 part
└─sdb4   8:20   0   5G  0 part
```

Now we will mount /dev/sdb1 to /m

```bash
server@ubuntuserver:~$ sudo mount /dev/sdb1 /mnt/
server@ubuntuserver:~$ sudo lsblk /dev/sdb
[sudo] password for server:
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
sdb      8:16   0  20G  0 disk
├─sdb1   8:17   0   5G  0 part /mnt
├─sdb2   8:18   0   5G  0 part
├─sdb3   8:19   0   5G  0 part
└─sdb4   8:20   0   5G  0 part
```

Now sdb1 partition has been mounted to /mnt directory.

### Unmounting

```bash
server@ubuntuserver:~$ apropos umount
mountsnoop-bpfcc (8) - Trace mount() and umount() syscalls. Uses Linux eBPF/bcc.
systemd-umount (1)   - Establish and destroy transient mount or auto-mount points
umount (2)           - unmount filesystem
umount (8)           - unmount filesystems
umount.udisks2 (8)   - unmount file systems that have been mounted by UDisks2
umount2 (2)          - unmount filesystem
```

The command line to umount the partition is “umount”

```bash
server@ubuntuserver:~$ sudo umount /mnt
server@ubuntuserver:~$ sudo lsblk /dev/sdb1
NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
sdb1   8:17   0   5G  0 part
```

Now /dev/sdb1 partition has been unmounted from /mnt directory

### **Implementation Persistent Mounting**

The file for persistent mounting is /etc/fstab

```bash
root@ubuntuserver:/# cat /etc/fstab
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
```

That file has a six fields. 

1 = block device file [Partition or Storage Space]

2 = mount point

3 = File System Type 

4 = mount option 

5 = Utility [0 means backup disabled, 1 means backup enabled]

6 = Specify what happens when the error is detected [0 = Never scan for errors, 1 = should scan first for error before other one, 2 = should scan after the one with the value of one have been scanned ]

Normally 1 for root file system where the operating system is installed 

2 for the other operating system 

```bash
root@ubuntuserver:/# mkdir mybackup
root@ubuntuserver:/# ls
bin                cdrom  home   lib.usr-is-merged  mnt       proc  sbin                srv       sys  var
bin.usr-is-merged  dev    lib    lost+found         mybackup  root  sbin.usr-is-merged  swap      tmp
boot               etc    lib64  media              opt       run   snap                swap.img  usr
root@ubuntuserver:/# sudo vim /etc/fstab
```

```bash
root@ubuntuserver:/mnt# cat /etc/fstab
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
/dev/sdb1       /mnt/sdb1       xfs     defaults        0       2
/dev/sdb2       /mnt/sdb2      ext4     defaults        0       2

root@ubuntuserver:/# systemctl daemon-reload
root@ubuntuserver:/# sudo reboot
```

After reboot, there is a mount point for sdb1 and sdb2 partitions. Lets also add sdb4 which is used as the swap as the persistent swap area. 

```bash
server@ubuntuserver:~$ sudo lsblk /dev/sdb
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
sdb      8:16   0  20G  0 disk
├─sdb1   8:17   0   5G  0 part /mnt/sdb1
├─sdb2   8:18   0   5G  0 part /mnt/sdb2
├─sdb3   8:19   0   5G  0 part
└─sdb4   8:20   0   5G  0 part

server@ubuntuserver:~$ sudo lsblk -f /dev/sdb4
NAME FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sdb4 swap   1           59e4fc0f-e586-4682-9cc3-73d269f65583
```

```bash
server@ubuntuserver:~$ cat /etc/fstab
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
/dev/sdb1       /mnt/sdb1       xfs     defaults        0       2
/dev/sdb2       /mnt/sdb2      ext4     defaults        0       2
/dev/sdb4       none    swap    defaults        0       0

server@ubuntuserver:~$ sudo reboot
server@ubuntuserver:~$ sudo systemctl daemon-reload
```

At the last two fields, we specify 0 0 because swap is not meant to be back up or scanned for errors. 

After reboot, we can see that /dev/sdb4 is used as the swap point.

```bash
server@ubuntuserver:~$ swapon --show
NAME      TYPE      SIZE USED PRIO
/swap.img file        2G   0B   -2
/dev/sdb4 partition   5G   0B   -3
```