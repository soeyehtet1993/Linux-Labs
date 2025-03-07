# Create and Configure File System

By default, ubuntu use the ext4 file system and redhat use the xfs file system.

### Configure XFS file system

```bash
Device        Start      End  Sectors Size Type
/dev/sdb1      2048 20973567 20971520  10G Linux filesystem
/dev/sdb2  20973568 31459327 10485760   5G Linux filesystem
/dev/sdb3  31459328 41940991 10481664   5G Linux swap
```

We will partition sdb1 into two partition first.

```bash
server@ubuntuserver:~$ sudo cfdisk /dev/sdb

Device        Start      End  Sectors Size Type
/dev/sdb1      2048 10487807 10485760   5G Linux filesystem
/dev/sdb2  10487808 20973567 10485760   5G Linux filesystem
/dev/sdb3  20973568 31459327 10485760   5G Linux filesystem
/dev/sdb4  31459328 41940991 10481664   5G Linux swap
```

```bash
server@ubuntuserver:~$ apropos xfs
filesystems (5)      - Linux filesystem types: ext, ext2, ext3, ext4, hpfs, iso9660, JFS, minix, msdos, ncpfs nfs, nt...
fs (5)               - Linux filesystem types: ext, ext2, ext3, ext4, hpfs, iso9660, JFS, minix, msdos, ncpfs nfs, nt...
fsck.xfs (8)         - do nothing, successfully
fsfreeze (8)         - suspend access to a filesystem (Ext3/4, ReiserFS, JFS, XFS)
mkfs.xfs (8)         - construct an XFS filesystem
```

Now we will set sdb1 partition into XFS Fliesystem.

```bash
server@ubuntuserver:~$ sudo mkfs.xfs -L "BackupVolume" /dev/sdb1
meta-data=/dev/sdb1              isize=512    agcount=4, agsize=327680 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=1310720, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```

```bash
server@ubuntuserver:~$ sudo lsblk -f /dev/sdb1
NAME FSTYPE FSVER LABEL        UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sdb1 xfs          BackupVolume aa26cc63-bd89-4236-b4b0-ecfe5e768da7
```

now file type of “sdb1” partition is xfs. We will overwrite as we want to set size=512 for that partition by using -f flag.

```bash
server@ubuntuserver:~$ sudo mkfs.xfs -i size=512 -f /dev/sdb1
meta-data=/dev/sdb1              isize=512    agcount=4, agsize=327680 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=1310720, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```

```bash
server@ubuntuserver:~$ sudo lsblk -f /dev/sdb1
NAME FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sdb1 xfs                5c3898a7-7108-4778-b1fe-f1c1edfec331
```

Oops… Let’s label again for that partition.

```bash
server@ubuntuserver:~$ sudo mkfs.xfs -f -i size=512 -L "BackUpVolume" /dev/sdb1
meta-data=/dev/sdb1              isize=512    agcount=4, agsize=327680 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=1310720, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
server@ubuntuserver:~$ sudo lsblk -f /dev/sdb1
NAME FSTYPE FSVER LABEL        UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sdb1 xfs          BackUpVolume 4105ca36-ce58-4335-bc5a-01f7f2346b18
server@ubuntuserver:~$
```

Lets change the label for “dev/sdb1” partition.

```bash
server@ubuntuserver:~$ sudo xfs_admin -l /dev/sdb1
label = "BackUpVolume"
server@ubuntuserver:~$ sudo xfs_admin -L "FirstFS" /dev/sdb1
writing all SBs
new label = "FirstFS"
server@ubuntuserver:~$ sudo xfs_admin -l /dev/sdb1
label = "FirstFS"

server@ubuntuserver:~$ sudo xfs_info /dev/sdb1
meta-data=/dev/sdb1              isize=512    agcount=4, agsize=327680 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=1310720, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```

### Configure EXT4

Let’s file the command to configure file system for EXT4. 

```bash
server@ubuntuserver:~$ apropos "ext4" | grep "create"
mke2fs (8)           - create an ext2/ext3/ext4 file system
mkfs.ext2 (8)        - create an ext2/ext3/ext4 file system
mkfs.ext3 (8)        - create an ext2/ext3/ext4 file system
mkfs.ext4 (8)        - create an ext2/ext3/ext4 file system
```

now we will use “mkfs.ext4” command line for our purpose. We will set ext4 file system type for partition name “/dev/sdb2”.

```bash
server@ubuntuserver:~$ sudo mkfs.ext4 /dev/sdb2
mke2fs 1.47.0 (5-Feb-2023)
Creating filesystem with 1310720 4k blocks and 327680 inodes
Filesystem UUID: d4f4c6c2-53ce-4a21-a902-85521fe245a1
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

```bash
server@ubuntuserver:~$ sudo lsblk -f /dev/sdb2
NAME FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sdb2 ext4   1.0         d4f4c6c2-53ce-4a21-a902-85521fe245a1
```

Now, file system type for “/dev/sdb2” is ext4. 

```bash
server@ubuntuserver:~$ mkfs.ext4
Usage: mkfs.ext4 [-c|-l filename] [-b block-size] [-C cluster-size]
        [-i bytes-per-inode] [-I inode-size] [-J journal-options]
        [-G flex-group-size] [-N number-of-inodes] [-d root-directory]
        [-m reserved-blocks-percentage] [-o creator-os]
        [-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]
        [-O feature[,...]] [-r fs-revision] [-E extended-option[,...]]
        [-t fs-type] [-T usage-type ] [-U UUID] [-e errors_behavior][-z undo_file]
        [-jnqvDFSV] device [blocks-count]
```

What is inode?

If we cannot create any new files although we still have the hundreds of gigabytes of free space, it means we run out of the inode. Each file or directory uses an inode. If we have a plan to put many small files, we can set large number at Number of inodes for ext4 file system type. 

```bash
server@ubuntuserver:~$ sudo mkfs.ext4 -N 500000 /dev/sdb2
mke2fs 1.47.0 (5-Feb-2023)
/dev/sdb2 contains a ext4 file system
        created on Fri Mar  7 08:00:44 2025
Proceed anyway? (y,N) y
Creating filesystem with 1310720 4k blocks and 500480 inodes
Filesystem UUID: 1da15428-14e2-47a0-b3f2-9894cf6398de
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

```bash
server@ubuntuserver:~$ sudo tune2fs -l /dev/sdb2
tune2fs 1.47.0 (5-Feb-2023)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          1da15428-14e2-47a0-b3f2-9894cf6398de
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              500480
Block count:              1310720
Reserved block count:     65536
Overhead clusters:        52872
Free blocks:              1257842
Free inodes:              500469
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Reserved GDT blocks:      639
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         12512
Inode blocks per group:   782
Flex block group size:    16
Filesystem created:       Fri Mar  7 08:04:58 2025
Last mount time:          n/a
Last write time:          Fri Mar  7 08:04:58 2025
Mount count:              0
Maximum mount count:      -1
Last checked:             Fri Mar  7 08:04:58 2025
Check interval:           0 (<none>)
Lifetime writes:          2589 kB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     32
Desired extra isize:      32
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      9612702c-87cd-4c40-8960-5a14ead692c7
Journal backup:           inode blocks
Checksum type:            crc32c
Checksum:                 0x7275bbdf
```

Now set the label for “/dev/sdb2”

```bash
server@ubuntuserver:~$ sudo tune2fs -L "SecondFS" /dev/sdb2
tune2fs 1.47.0 (5-Feb-2023)
```

Now we can see the Label with the name “SecondFS” is set for /dev/sdb2.

```bash
server@ubuntuserver:~$ sudo lsblk -f /dev/sdb2
NAME FSTYPE FSVER LABEL    UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
sdb2 ext4   1.0   SecondFS 1da15428-14e2-47a0-b3f2-9894cf6398de
```