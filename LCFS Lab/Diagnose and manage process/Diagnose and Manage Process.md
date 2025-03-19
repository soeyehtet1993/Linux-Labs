# Diagnose and Manage Process

In order to report the current process, we can use ps command. 

### To view the current running process

```bash
server@ubuntuserver:~$ ps
    PID TTY          TIME CMD
   1690 pts/0    00:00:00 bash
   1750 pts/0    00:00:00 ps
```

### To see every process on the system using BSD syntax:

```bash
server@ubuntuserver:~$ ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.5  0.6  22376 13480 ?        Ss   18:59   0:01 /sbin/init
root           2  0.0  0.0      0     0 ?        S    18:59   0:00 [kthreadd]
root           3  0.0  0.0      0     0 ?        S    18:59   0:00 [pool_workqueue_release]
root           4  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-rcu_g]
root           5  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-rcu_p]
root           6  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-slub_]
root           7  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-netns]
root           8  0.1  0.0      0     0 ?        I    18:59   0:00 [kworker/0:0-events]
root           9  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/0:0H-events_highpri]
root          10  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/0:1-rcu_par_gp]
root          11  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u256:0-ext4-rsv-conversion]
root          12  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-mm_pe]
root          13  0.0  0.0      0     0 ?        I    18:59   0:00 [rcu_tasks_kthread]
root          14  0.0  0.0      0     0 ?        I    18:59   0:00 [rcu_tasks_rude_kthread]
root          15  0.0  0.0      0     0 ?        I    18:59   0:00 [rcu_tasks_trace_kthread]
root          16  0.0  0.0      0     0 ?        S    18:59   0:00 [ksoftirqd/0]
root          17  0.0  0.0      0     0 ?        I    18:59   0:00 [rcu_preempt]
root          18  0.0  0.0      0     0 ?        S    18:59   0:00 [migration/0]
root          19  0.0  0.0      0     0 ?        S    18:59   0:00 [idle_inject/0]
root          20  0.0  0.0      0     0 ?        S    18:59   0:00 [cpuhp/0]
root          21  0.0  0.0      0     0 ?        S    18:59   0:00 [cpuhp/1]
root          22  0.0  0.0      0     0 ?        S    18:59   0:00 [idle_inject/1]
root          23  0.0  0.0      0     0 ?        S    18:59   0:00 [migration/1]
root          24  0.0  0.0      0     0 ?        S    18:59   0:00 [ksoftirqd/1]
root          25  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/1:0-events]
root          26  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/1:0H-kblockd]
root          27  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u257:0-loop4]
root          28  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:0-events_unbound]
root          29  0.0  0.0      0     0 ?        S    18:59   0:00 [kdevtmpfs]
root          30  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-inet_]
root          31  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u257:1-flush-252:0]
root          32  0.0  0.0      0     0 ?        S    18:59   0:00 [kauditd]
root          33  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/0:2-events]
root          34  0.0  0.0      0     0 ?        S    18:59   0:00 [khungtaskd]
root          35  0.0  0.0      0     0 ?        S    18:59   0:00 [oom_reaper]
root          36  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u257:2-events_power_efficient]
root          37  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-write]
root          38  0.0  0.0      0     0 ?        S    18:59   0:00 [kcompactd0]
root          39  0.0  0.0      0     0 ?        SN   18:59   0:00 [ksmd]
root          40  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/1:1-events]
root          41  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/1:2-events]
root          42  0.0  0.0      0     0 ?        SN   18:59   0:00 [khugepaged]
root          43  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-kinte]
root          44  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-kbloc]
root          45  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-blkcg]
root          46  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/9-acpi]
root          47  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-tpm_d]
root          48  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-ata_s]
root          49  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-md]
root          50  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-md_bi]
root          51  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-edac-]
root          52  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-devfr]
root          53  0.0  0.0      0     0 ?        S    18:59   0:00 [watchdogd]
root          54  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:1-events_unbound]
root          55  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/1:1H-kblockd]
root          56  0.0  0.0      0     0 ?        S    18:59   0:00 [kswapd0]
root          57  0.0  0.0      0     0 ?        S    18:59   0:00 [ecryptfs-kthread]
root          58  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-kthro]
root          59  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/24-pciehp]
root          60  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/25-pciehp]
root          61  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/26-pciehp]
root          62  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/27-pciehp]
root          63  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/28-pciehp]
root          64  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/29-pciehp]
root          65  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/30-pciehp]
root          66  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/31-pciehp]
root          67  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/32-pciehp]
root          68  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/33-pciehp]
root          69  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/34-pciehp]
root          70  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/35-pciehp]
root          71  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/36-pciehp]
root          72  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/37-pciehp]
root          73  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/38-pciehp]
root          74  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/39-pciehp]
root          75  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/40-pciehp]
root          76  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/41-pciehp]
root          77  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/42-pciehp]
root          78  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/43-pciehp]
root          79  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/44-pciehp]
root          80  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/45-pciehp]
root          81  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/46-pciehp]
root          82  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/47-pciehp]
root          83  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/48-pciehp]
root          84  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/49-pciehp]
root          85  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/50-pciehp]
root          86  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/51-pciehp]
root          87  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/52-pciehp]
root          88  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/53-pciehp]
root          89  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/54-pciehp]
root          90  0.0  0.0      0     0 ?        S    18:59   0:00 [irq/55-pciehp]
root          91  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-acpi_]
root          92  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_0]
root          93  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root          94  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_1]
root          95  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root          96  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u257:3-loop1]
root          97  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u257:4-events_freezable_power_]
root          98  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-mld]
root          99  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/0:1H-kblockd]
root         100  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-ipv6_]
root         107  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-kstrp]
root         109  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/u259:0]
root         110  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/u260:0]
root         111  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/u261:0]
root         116  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-crypt]
root         117  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/0:3-rcu_par_gp]
root         118  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/0:4-rcu_gp]
root         127  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-charg]
root         170  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-mpt_p]
root         171  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-mpt/0]
root         188  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_2]
root         189  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         190  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_3]
root         191  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         192  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_4]
root         193  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         194  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_5]
root         195  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         196  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_6]
root         197  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         198  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_7]
root         199  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         200  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_8]
root         201  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         202  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_9]
root         203  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         204  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_10]
root         205  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         206  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_11]
root         207  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         208  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_12]
root         209  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         210  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_13]
root         211  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         212  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_14]
root         213  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         215  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_15]
root         216  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         217  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_16]
root         218  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         220  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_17]
root         221  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         222  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_18]
root         225  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         230  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_19]
root         233  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         234  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_20]
root         235  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         236  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_21]
root         238  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         239  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_22]
root         240  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         241  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_23]
root         242  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         244  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_24]
root         245  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         246  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_25]
root         247  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         248  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_26]
root         249  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         252  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_27]
root         253  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         254  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_28]
root         255  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         256  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_29]
root         257  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         258  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_30]
root         263  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         265  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_31]
root         266  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         267  0.0  0.0      0     0 ?        S    18:59   0:00 [scsi_eh_32]
root         269  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-scsi_]
root         271  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:2-events_unbound]
root         272  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:3-events_unbound]
root         273  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:4-events_unbound]
root         274  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:5-events_unbound]
root         276  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:6-events_unbound]
root         277  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:7-events_unbound]
root         278  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:8-events_unbound]
root         279  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:9-events_unbound]
root         280  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:10-events_unbound]
root         281  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:11-events_unbound]
root         282  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:12-events_unbound]
root         283  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:13-events_unbound]
root         284  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:14-events_unbound]
root         286  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:15-events_unbound]
root         287  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:16-events_unbound]
root         289  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:17-events_unbound]
root         290  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:18-events_unbound]
root         291  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:19-events_unbound]
root         292  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:20-events_unbound]
root         293  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-kdmfl]
root         294  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:21-events_unbound]
root         295  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:22-events_unbound]
root         296  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:23-events_unbound]
root         297  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:24-events_unbound]
root         298  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:25-flush-252:0]
root         299  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:26-events_power_efficient]
root         300  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:27-events_unbound]
root         301  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:28-events_power_efficient]
root         302  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:29-events_unbound]
root         303  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:30-events_unbound]
root         304  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/u258:31]
root         341  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-raid5]
root         388  0.0  0.0      0     0 ?        S    18:59   0:00 [jbd2/dm-0-8]
root         389  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-ext4-]
root         465  0.0  0.8  42248 16752 ?        S<s  18:59   0:00 /usr/lib/systemd/systemd-journald
root         468  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-rpcio]
root         469  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-xprti]
root         490  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-kmpat]
root         492  0.0  0.0      0     0 ?        I<   18:59   0:00 [kworker/R-kmpat]
root         504  0.0  1.3 354652 27264 ?        SLsl 18:59   0:00 /sbin/multipathd -d -s
root         531  0.0  0.0      0     0 ?        I    19:00   0:00 [kworker/u256:1]
root         533  0.0  0.4  30640  9344 ?        Ss   19:00   0:00 /usr/lib/systemd/systemd-udevd
root         557  0.0  0.0      0     0 ?        S    19:00   0:00 [psimon]
root         582  0.0  0.0      0     0 ?        I    19:00   0:00 [kworker/u257:5-events_power_efficient]
root         676  0.0  0.0      0     0 ?        I    19:00   0:00 [kworker/1:3-cgroup_destroy]
root         678  0.0  0.0      0     0 ?        S    19:00   0:00 [irq/57-vmw_vmci]
root         679  0.0  0.0      0     0 ?        S    19:00   0:00 [irq/58-vmw_vmci]
root         681  0.0  0.0      0     0 ?        S    19:00   0:00 [irq/59-vmw_vmci]
root         685  0.0  0.0      0     0 ?        S    19:00   0:00 [jbd2/sda2-8]
root         686  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/R-ext4-]
root         689  0.0  0.0      0     0 ?        S    19:00   0:00 [jbd2/sdb2-8]
root         690  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/R-ext4-]
root         691  0.0  0.0      0     0 ?        S    19:00   0:00 [irq/16-vmwgfx]
root         692  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/R-ttm]
root         694  0.0  0.0      0     0 ?        S    19:00   0:00 [jbd2/sdb3-8]
root         695  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/R-ext4-]
root         698  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/R-xfsal]
root         699  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/R-xfs_m]
root         700  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/R-xfs-b]
root         701  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/R-xfs-c]
root         702  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/R-xfs-r]
root         703  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/R-xfs-b]
root         704  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/R-xfs-i]
root         705  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/R-xfs-l]
root         706  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/R-xfs-c]
root         707  0.0  0.0      0     0 ?        S    19:00   0:00 [xfsaild/sdb1]
_rpc         763  0.0  0.2   7968  3968 ?        Ss   19:00   0:00 /sbin/rpcbind -f -w
systemd+     776  0.0  0.6  21580 12800 ?        Ss   19:00   0:00 /usr/lib/systemd/systemd-resolved
systemd+     781  0.0  0.3  91020  7680 ?        Ssl  19:00   0:00 /usr/lib/systemd/systemd-timesyncd
root         912  0.0  0.6  53464 12032 ?        Ss   19:00   0:00 /usr/bin/VGAuthService
root         915  0.1  0.4 242236  9216 ?        Ssl  19:00   0:00 /usr/bin/vmtoolsd
systemd+     929  0.0  0.4  19004  9600 ?        Ss   19:00   0:00 /usr/lib/systemd/systemd-networkd
root         997  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/R-cfg80]
message+    1151  0.0  0.2   9788  5376 ?        Ss   19:00   0:00 @dbus-daemon --system --address=systemd: --nofork --n
root        1167  0.0  0.1   5428  3456 ?        Ss   19:00   0:00 /usr/sbin/fsidd
polkitd     1184  0.0  0.4 308160  7936 ?        Ssl  19:00   0:00 /usr/lib/polkit-1/polkitd --no-debug
root        1204  0.3  1.6 1321444 32380 ?       Ssl  19:00   0:01 /usr/lib/snapd/snapd
root        1216  0.0  0.4  17988  8704 ?        Ss   19:00   0:00 /usr/lib/systemd/systemd-logind
root        1218  0.0  0.6 469228 13696 ?        Ssl  19:00   0:00 /usr/libexec/udisks2/udisksd
syslog      1270  0.0  0.3 222508  6272 ?        Ssl  19:00   0:00 /usr/sbin/rsyslogd -n -iNONE
root        1272  0.0  0.0   5140  1536 ?        Ss   19:00   0:00 /usr/sbin/blkmapd
root        1273  0.0  0.1   5632  2944 ?        Ss   19:00   0:00 /usr/sbin/nfsdcld
root        1278  0.0  0.0      0     0 ?        I<   19:00   0:00 [kworker/1:2H-kblockd]
root        1279  0.0  1.1 109672 22912 ?        Ssl  19:00   0:00 /usr/bin/python3 /usr/share/unattended-upgrades/unatt
root        1296  0.0  0.6 392092 12672 ?        Ssl  19:00   0:00 /usr/sbin/ModemManager
root        1381  0.0  0.1   3008  2308 ?        Ss   19:00   0:00 /usr/sbin/rpc.idmapd
root        1382  0.0  0.1   6824  2688 ?        Ss   19:00   0:00 /usr/sbin/cron -f -P
root        1391  0.0  0.0  43212  1936 ?        Ss   19:00   0:00 /usr/sbin/rpc.mountd
statd       1392  0.0  0.0   4560  1924 ?        Ss   19:00   0:00 /usr/sbin/rpc.statd
root        1404  0.0  0.4  12020  7936 ?        Ss   19:00   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startu
root        1406  0.0  0.2  12600  4012 ?        Ss   19:00   0:00 /bin/nbd-server
root        1412  0.0  0.0      0     0 ?        I    19:00   0:00 [lockd]
root        1418  0.0  0.0      0     0 ?        I    19:00   0:00 [kworker/1:4]
root        1421  0.0  0.0   6104  1920 tty1     Ss+  19:00   0:00 /sbin/agetty -o -p -- \u --noclear - linux
root        1423  0.0  0.0      0     0 ?        I    19:00   0:00 [nfsd]
root        1424  0.0  0.0      0     0 ?        I    19:00   0:00 [nfsd]
root        1425  0.0  0.0      0     0 ?        I    19:00   0:00 [nfsd]
root        1426  0.0  0.0      0     0 ?        I    19:00   0:00 [nfsd]
root        1427  0.0  0.0      0     0 ?        I    19:00   0:00 [nfsd]
root        1428  0.0  0.0      0     0 ?        I    19:00   0:00 [nfsd]
root        1429  0.0  0.0      0     0 ?        I    19:00   0:00 [nfsd]
root        1430  0.0  0.0      0     0 ?        I    19:00   0:00 [nfsd]
root        1533  0.0  0.4  14964  7968 ?        Ss   19:02   0:00 sshd: server [priv]
root        1536  0.0  0.0      0     0 ?        S    19:02   0:00 [psimon]
server      1538  0.0  0.5  20380 11392 ?        Ss   19:02   0:00 /usr/lib/systemd/systemd --user
server      1539  0.0  0.1  21144  3516 ?        S    19:02   0:00 (sd-pam)
server      1687  0.1  0.3  15124  6960 ?        S    19:02   0:00 sshd: server@pts/0
server      1690  0.0  0.2   8648  5504 pts/0    Ss   19:02   0:00 -bash
root        1732  0.0  0.0      0     0 ?        I<   19:02   0:00 [kworker/R-tls-s]
server      1766  0.0  0.2  11012  4480 pts/0    R+   19:04   0:00 ps aux
```

u = Display user-oriented format.

ax = to display all processes

### How to read the ps aux

%CPU = the percentage of CPU which is currently used by one core CPU 

- if %CPU = 100% ⇒  entire one CPU core is used

%MEM = the percentage of utilized memory by the process 

TIME = How much CPU time is used for the process 

COMMAND = the command line which make the process 

- if the command is wrapped with “[” and “]”, that process is the kernel process inside the privileged area of linux kernel [e.g  [kworker/R-ext4-] ]

### Display Linux processes continuously

“top” command can be used to display the linux process continuously. The process which consume mostly the CPU will be displayed at the top.

```bash
top - 19:16:08 up 16 min,  1 user,  load average: 0.06, 0.01, 0.00
Tasks: 243 total,   2 running, 241 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.2 us,  0.3 sy,  0.0 ni, 99.5 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :   1920.0 total,   1260.2 free,    413.2 used,    400.4 buff/cache
MiB Swap:   7166.0 total,   7166.0 free,      0.0 used.   1506.7 avail Mem

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
   1687 server    20   0   15124   6960   4992 S   0.7   0.4   0:01.06 sshd
   1854 server    20   0   11912   5888   3712 R   0.3   0.3   0:00.02 top
      1 root      20   0   22376  13480   9512 S   0.0   0.7   0:01.77 systemd
      2 root      20   0       0      0      0 S   0.0   0.0   0:00.01 kthreadd
      3 root      20   0       0      0      0 S   0.0   0.0   0:00.00 pool_workqueue_release
      4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-rcu_g
      5 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-rcu_p
      6 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-slub_
      7 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-netns
      8 root      20   0       0      0      0 I   0.0   0.0   0:01.08 kworker/0:0-events
      9 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/0:0H-events_highpri
     11 root      20   0       0      0      0 I   0.0   0.0   0:00.00 kworker/u256:0-ext4-rsv-conversion
     12 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-mm_pe
     13 root      20   0       0      0      0 I   0.0   0.0   0:00.00 rcu_tasks_kthread
     14 root      20   0       0      0      0 I   0.0   0.0   0:00.00 rcu_tasks_rude_kthread
     15 root      20   0       0      0      0 I   0.0   0.0   0:00.00 rcu_tasks_trace_kthread
```

### Display the specific process ID with user-oriented format

```bash
server@ubuntuserver:~$ ps u 1
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.1  0.6  22376 13480 ?        Ss   18:59   0:01 /sbin/init
```

### Display the processes by user with user-oriented format

```bash
server@ubuntuserver:~$ ps u -U server
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
server      1538  0.0  0.5  20380 11392 ?        Ss   19:02   0:00 /usr/lib/systemd/systemd --user
server      1539  0.0  0.1  21144  3516 ?        S    19:02   0:00 (sd-pam)
server      1687  0.1  0.3  15124  6960 ?        S    19:02   0:01 sshd: server@pts/0
server      1690  0.0  0.2   8648  5504 pts/0    Ss   19:02   0:00 -bash
server      1862  0.0  0.2  11012  4480 pts/0    R+   19:19   0:00 ps u -U server
```

### To look for processes based on name and other attributes

```bash
server@ubuntuserver:~$ pgrep -a ssh
1404 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
1533 sshd: server [priv]
1687 sshd: server@pts/0
```

### Nice value

The nice value can be a number between -20  and 19. The lower the number, the higher the priority. 

Nice value of process A = -20 

Nice value of process B = 19 

If process A and process B runs at the same time, most CPU resources will be used to run the process A. 

To assign the nice value to the process we can use the following syntax. 

nice -n [NICE VALUE] [COMMAND] ⇒ nice -n 11 bash 

to display the nice value in the ps, we can use “l” option.

```bash
server@ubuntuserver:~$ ps l
F   UID     PID    PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY        TIME COMMAND
0  1002    1690    1687  20   0   8648  5504 do_wai Ss   pts/0      0:00 -bash
0  1002    1891    1690  20   0  11048  4352 -      R+   pts/0      0:00 ps l
```

or we can reassign the new nice value to the running process 

renice [New Nice Value] [PID] 

> remark : if we want to change the nice value to lower value [ for example from 9 to 6] only root user can lower the nice value
> 

### To see the child and process are we can use “F” option

```bash
   server@ubuntuserver:~$ ps fax
   1404 ?        Ss     0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
   1533 ?        Ss     0:00  \_ sshd: server [priv]
   1687 ?        S      0:01      \_ sshd: server@pts/0
   1690 pts/0    Ss     0:00          \_ -bash
   1897 pts/0    R+     0:00              \_ ps fax
```

### Signaling to the process and kill the process

To list all the types of signals are 

```bash
server@ubuntuserver:~$ kill -L
 1) SIGHUP       2) SIGINT       3) SIGQUIT      4) SIGILL       5) SIGTRAP
 6) SIGABRT      7) SIGBUS       8) SIGFPE       9) SIGKILL     10) SIGUSR1
11) SIGSEGV     12) SIGUSR2     13) SIGPIPE     14) SIGALRM     15) SIGTERM
16) SIGSTKFLT   17) SIGCHLD     18) SIGCONT     19) SIGSTOP     20) SIGTSTP
21) SIGTTIN     22) SIGTTOU     23) SIGURG      24) SIGXCPU     25) SIGXFSZ
26) SIGVTALRM   27) SIGPROF     28) SIGWINCH    29) SIGIO       30) SIGPWR
31) SIGSYS      34) SIGRTMIN    35) SIGRTMIN+1  36) SIGRTMIN+2  37) SIGRTMIN+3
38) SIGRTMIN+4  39) SIGRTMIN+5  40) SIGRTMIN+6  41) SIGRTMIN+7  42) SIGRTMIN+8
43) SIGRTMIN+9  44) SIGRTMIN+10 45) SIGRTMIN+11 46) SIGRTMIN+12 47) SIGRTMIN+13
48) SIGRTMIN+14 49) SIGRTMIN+15 50) SIGRTMAX-14 51) SIGRTMAX-13 52) SIGRTMAX-12
53) SIGRTMAX-11 54) SIGRTMAX-10 55) SIGRTMAX-9  56) SIGRTMAX-8  57) SIGRTMAX-7
58) SIGRTMAX-6  59) SIGRTMAX-5  60) SIGRTMAX-4  61) SIGRTMAX-3  62) SIGRTMAX-2
63) SIGRTMAX-1  64) SIGRTMAX
```

the usage is “kill -SIGHUP 1457” or “kill -HUP 1457” 

Let’s kill the process 

```bash
server@ubuntuserver:~$ pgrep -a bash
1690 -bash
server@ubuntuserver:~$ bash
server@ubuntuserver:~$ pgrep -a bash
1690 -bash
1945 bash
```

and we are going to kill PID “1945” because this is another bash we open

```bash
server@ubuntuserver:~$ kill -9 1945
Killed

server@ubuntuserver:~$ pgrep -a bash
1690 -bash
```

or we can also kill with by putting SIGKILL in the command

```bash
server@ubuntuserver:~$ pgrep -a bash
1690 -bash
2010 bash

server@ubuntuserver:~$ kill -KILL 2010
Killed
server@ubuntuserver:~$ pgrep -a bash
1690 -bash
```

### Check the file of directories used by specific PID

the command line is “lsof”

```bash
server@ubuntuserver:~$ lsof -p 1690
COMMAND  PID   USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
bash    1690 server  cwd    DIR  252,0     4096  786447 /home/server
bash    1690 server  rtd    DIR  252,0     4096       2 /
bash    1690 server  txt    REG  252,0  1446024 2752980 /usr/bin/bash
bash    1690 server  mem    REG  252,0  3055776 2764807 /usr/lib/locale/locale-archive
bash    1690 server  mem    REG  252,0    27028 2761892 /usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache
bash    1690 server  mem    REG  252,0  2125328 2761903 /usr/lib/x86_64-linux-gnu/libc.so.6
bash    1690 server  mem    REG  252,0   208328 2764979 /usr/lib/x86_64-linux-gnu/libtinfo.so.6.4
bash    1690 server  mem    REG  252,0   236616 2761900 /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
bash    1690 server    0u   CHR  136,0      0t0       3 /dev/pts/0
bash    1690 server    1u   CHR  136,0      0t0       3 /dev/pts/0
bash    1690 server    2u   CHR  136,0      0t0       3 /dev/pts/0
bash    1690 server  255u   CHR  136,0      0t0       3 /dev/pts/0
```