---
linkTitle: Host Storage
title: Managing Host Storage
---

Ondat uses the storage available on the nodes where it is installed to
present as available for volumes.

In order to mitigate against problems caused by filling the host root disk, we
recommend mounting a separate device into the `/var/lib/storageos` directory.
Ondat is agnostic to the type of filesystem mounted in
`/var/lib/storageos`.

## Extending Available Storage

Ondat uses subdirectories of `/var/lib/storageos/data` to hold user data.
By default, the directory `/var/lib/storageos/data/dev1` will be created when a
node is bootstrapped, and used for pool data. It is possible to shard the data
by creating more directories into this structure. Ondat will save data in
any directory that conforms to the pattern `/var/lib/storageos/data/dev[0-9]+`,
such as `/var/lib/storageos/data/dev2` or `/var/lib/storageos/data/dev5`. This
functionality enables operators to mount different devices into devX
directories and Ondat will recognise them as available storage
automatically.

There are two possible options to expand the available disk space for Ondat
to allocate:

1. Mount filesystem in `/var/lib/storageos/data/devX`
1. Use LVM to expand the logical volume available to Ondat

## Option 1: Mount Additional Devices

This option enables operators to expand the cluster's available space at any
time without having to stop applications or forcing operational downtime. The
expansion of disk is transparent for applications and Ondat Volumes.
Ondat will use the new available space to create new data files.

1. Context

    We assume that there is a disk available in our Linux system without
    formatting in addition to the root filesystem. Ondat data dir dev1
    (`/var/lib/storageos/data/dev1`) is using `/dev/xvda1`. We will use the
    device `/dev/xvdf` to expand Ondat available space.

    List available block devices in the host.
    ```
    root@ip-172-20-58-239:~# lsblk
    NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    xvda    202:0    0  128G  0 disk
    `-xvda1 202:1    0  128G  0 part /
    xvdf    202:80   0  100G  0 disk
    ```

    Check Ondat cluster's available capacity.
    ```
    root@ip-172-20-58-239:~# storageos node ls --format="table {{.Name}}\t{{.Capacity}}"
    NAME                                          TOTAL
    ip-172-20-119-113.eu-west-1.compute.internal  128.7GB
    ip-172-20-58-239.eu-west-1.compute.internal   128.7GB
    ip-172-20-68-139.eu-west-1.compute.internal   128.7GB
    ip-172-20-84-11.eu-west-1.compute.internal    128.7GB
    ```

1. Format device
    ```
    root@ip-172-20-58-239:/var/lib/storageos/data# mkfs -t ext4 /dev/xvdf
    mke2fs 1.42.12 (29-Aug-2014)
    Creating filesystem with 26214400 4k blocks and 6553600 inodes
    Filesystem UUID: 380712fa-6f82-477a-81a5-d7466d4c6b7f
    Superblock backups stored on blocks:
            32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
            4096000, 7962624, 11239424, 20480000, 23887872

    Allocating group tables: done
    Writing inode tables: done
    Creating journal (32768 blocks): done
    Writing superblocks and filesystem accounting information: done
    ```

1. Mount filesystem
    ```
    root@ip-172-20-58-239:~# mkdir -p /var/lib/storageos/data/dev2
    root@ip-172-20-58-239:~# mount /dev/xvdf /var/lib/storageos/data/dev2
    ```

1. Verify available storage

    In less than 30 seconds, Ondat will see the new available capacity.

    ```
    root@ip-172-20-58-239:~# storageos node ls --format="table {{.Name}}\t{{.Capacity}}"
    NAME                                          TOTAL
    ip-172-20-119-113.eu-west-1.compute.internal  128.7GB
    ip-172-20-58-239.eu-west-1.compute.internal   227.3GB
    ip-172-20-68-139.eu-west-1.compute.internal   128.7GB
    ip-172-20-84-11.eu-west-1.compute.internal    128.7GB

    root@ip-172-20-58-239:/var/lib/storageos/data/dev2# lsblk
    NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    xvda    202:0    0  128G  0 disk
    `-xvda1 202:1    0  128G  0 part /
    xvdf    202:80   0  100G  0 disk /var/lib/storageos/data/dev2
    ```

    Note that the node ip-172-20-58-239.eu-west-1.compute.internal has increased the TOTAL capacity in
    100Gi.

> Persist the mount at boot by adding the mount endpoint to `/etc/fstab`


## Option 2: Expand Existing Devices Backed by LVM

This option enables operators to take advantage of LVM to manage disks.

1. Context

    We assume that `/var/lib/storageos` is mounted onto an LVM volume. We are
    using a volumegroup named `storageos` and logical volume called `data`. There
    is a second physical disk `/dev/xvdg` unused.


    List available block devices in the host.
    ```
    root@ip-172-20-84-11:~# lsblk
    NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    xvda             202:0    0  128G  0 disk
    `-xvda1          202:1    0  128G  0 part /
    xvdf             202:80   0  100G  0 disk
    `-storageos-data 254:0    0   99G  0 lvm  /var/lib/storageos
    xvdg             202:96   0  100G  0 disk
    ```

    Check Ondat cluster's available capacity.
    ```
    root@ip-172-20-84-11:~# storageos node ls --format="table {{.Name}}\t{{.Capacity}}"
    NAME                                          TOTAL
    ip-172-20-119-113.eu-west-1.compute.internal  128.7GB
    ip-172-20-58-239.eu-west-1.compute.internal   128.7GB
    ip-172-20-68-139.eu-west-1.compute.internal   128.7GB
    ip-172-20-84-11.eu-west-1.compute.internal    100.3GB # --> LVM storageos/data volume
    ```

1. Add physical disk to LVM

    ```
    root@ip-172-20-84-11:~# vgextend storageos /dev/xvdg
      Volume group "storageos" successfully extended
    ```

    The volume group `storageos` must have 2 physical volumes (#PV)
    ```
    root@ip-172-20-84-11:~# vgs
      VG        #PV #LV #SN Attr   VSize   VFree
      storageos   2   1   0 wz--n- 199.99g 104.99g
    ```

1. Extend logical volume `data`

    ```
    root@ip-172-20-84-11:~# lvextend -L+100G /dev/storageos/data
      Size of logical volume storageos/data changed from 95.00 GiB (24320 extents) to 195.00 GiB (49920 extents).
      Logical volume data successfully resized
    ```

1. Resize the FileSystem

    > Your filesystem must support the option to be expanded, and to do so
    > while in use. Otherwise, you need to unmount first.

    ```
    root@ip-172-20-84-11:~# resize2fs /dev/storageos/data
    resize2fs 1.42.12 (29-Aug-2014)
    Filesystem at /dev/storageos/data is mounted on /var/lib/storageos; on-line resizing required
    old_desc_blocks = 6, new_desc_blocks = 13
    The filesystem on /dev/storageos/data is now 51118080 (4k) blocks long.
    ```

1. Check new available space

    The mounted file system to `/var/lib/storageos` has increased its size.
    ```
    root@ip-172-20-84-11:~# df -h /dev/mapper/storageos-data
    Filesystem                  Size  Used Avail Use% Mounted on
    /dev/mapper/storageos-data  192G   60M  183G   1% /var/lib/storageos
    ```

    Ondat available storage has increased too.
    ```
    root@ip-172-20-84-11:~# storageos node ls --format="table {{.Name}}\t{{.Capacity}}"
    NAME                                          TOTAL
    ip-172-20-119-113.eu-west-1.compute.internal  128.7GB
    ip-172-20-58-239.eu-west-1.compute.internal   128.7GB
    ip-172-20-68-139.eu-west-1.compute.internal   128.7GB
    ip-172-20-84-11.eu-west-1.compute.internal    201GB # --> 100G more available
    ```

> Persist the mount at boot by adding the mount point to `/etc/fstab`
