# Configure and Manage the swap space

What is swap?

Swap is an area where Linux can move some data from the computer’s RAM.

```bash
server@ubuntuserver:/dev$ swapon --show
NAME      TYPE SIZE USED PRIO
/swap.img file   2G   0B   -2
server@ubuntuserver:/dev$

#The command line to check if the system uses any kind of swap areas. 
```

```bash
server@ubuntuserver:~$ sudo fdisk --list /dev/sdb
[sudo] password for server:
Disk /dev/sdb: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk model: VMware Virtual S
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 3641D574-90B1-4185-B791-30C7B130E9E7

Device        Start      End  Sectors Size Type
/dev/sdb1      2048 20973567 20971520  10G Linux filesystem
/dev/sdb2  20973568 31459327 10485760   5G Linux filesystem
/dev/sdb3  31459328 41940991 10481664   5G Linux swap
```

Although we configured sdb3 with 5G to use for swap, we need to format that partition as swap. 

```bash
server@ubuntuserver:~$ apropos swap
proc_swaps (5)       - swap areas
bswap (3)            - reverse order of bytes
bswap_16 (3)         - reverse order of bytes
bswap_32 (3)         - reverse order of bytes
bswap_64 (3)         - reverse order of bytes
mkswap (8)           - set up a Linux swap area
swab (3)             - swap adjacent bytes
swapcontext (3)      - manipulate user context
swapin-bpfcc (8)     - Count swapins by process. Uses BCC/eBPF.
swapin.bt (8)        - Count swapins by process. Uses bpftrace/eBPF.
swaplabel (8)        - print or change the label or UUID of a swap area
swapoff (2)          - start/stop swapping to file/device
swapoff (8)          - enable/disable devices and files for paging and swapping
swapon (2)           - start/stop swapping to file/device
swapon (8)           - enable/disable devices and files for paging and swapping
systemd-gpt-auto-generator (8) - Generator for automatically discovering and mounting root, /home/, /srv/, /var/ and ...
systemd-mkswap@.service (8) - Creating and growing file systems on demand
systemd.swap (5)     - Swap unit configuration
TAILQ_SWAP (3)       - implementation of a doubly linked tail queue
```

as we can see mkswap is the command we want to use for our purpose.

```bash
server@ubuntuserver:~$ sudo mkswap /dev/sdb3
Setting up swapspace version 1, size = 5 GiB (5366607872 bytes)
no label, UUID=9363143a-307d-4c70-ba79-40a4f84ddbd1

server@ubuntuserver:~$ sudo swapon --verbose /dev/sdb3
swapon: /dev/sdb3: found signature [pagesize=4096, signature=swap]
swapon: /dev/sdb3: pagesize=4096, swapsize=5366611968, devsize=5366611968
swapon /dev/sdb3

server@ubuntuserver:~$ sudo swapon --show
NAME      TYPE      SIZE USED PRIO
/swap.img file        2G   0B   -2
/dev/sdb3 partition   5G   0B   -3
```

Lets reboot the machine. After reboot, we can see that /dev/sdb3 is not used anymore as swap partition.

```bash
server@ubuntuserver:~$ sudo swapon --show
[sudo] password for server:
NAME      TYPE SIZE USED PRIO
/swap.img file   2G   0B   -2

server@ubuntuserver:~$ sudo mkswap /dev/sdb3
mkswap: /dev/sdb3: warning: wiping old swap signature.
Setting up swapspace version 1, size = 5 GiB (5366607872 bytes)
no label, UUID=59e4fc0f-e586-4682-9cc3-73d269f65583
server@ubuntuserver:~$ sudo swapon /dev/sdb3
server@ubuntuserver:~$ sudo swapon --show
NAME      TYPE      SIZE USED PRIO
/swap.img file        2G   0B   -2
/dev/sdb3 partition   5G   0B   -3
```

If we want to stop using “/dev/sdb3/” as the swap partition, we can do as per following.

```bash
server@ubuntuserver:~$ sudo swapoff /dev/sdb3
server@ubuntuserver:~$ sudo swapon --show
NAME      TYPE SIZE USED PRIO
/swap.img file   2G   0B   -2
```

“/swap.img” is the simple file which used as the swap. It come as a default file in ubuntu.

we can also create similar kind of file with by this 

```bash
root@ubuntuserver:/# sudo dd if=/dev/zero of=/swap bs=1M count=2048
2048+0 records in
2048+0 records out
2147483648 bytes (2.1 GB, 2.0 GiB) copied, 4.28054 s, 502 MB/s

root@ubuntuserver:/# ls | grep 'swap'
swap
swap.img

root@ubuntuserver:/# chmod 600 swap

root@ubuntuserver:/# mkswap /swap
mkswap: /swap: warning: wiping old swap signature.
Setting up swapspace version 1, size = 2 GiB (2147479552 bytes)
no label, UUID=2a684781-5e72-4710-b876-b5845912e257

root@ubuntuserver:/# swapon /swap

root@ubuntuserver:/# swapon --verbose
NAME      TYPE SIZE USED PRIO
/swap.img file   2G  12K   -2
/swap     file   2G   0B   -3
```