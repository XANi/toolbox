## Common

* `ceph -w` - show running cluster ops (recovery etc)




## Version management

* `ceph versions` - show versions of daemons in cluster
* `ceph features` - show enabled feature level (i.e do not allow lower level to connect)

## Key management

Note that create options cant modify existing permissions, you have to use `auth caps` for it

* `ceph auth get-or-create client.nagios mon 'allow r'` - create nagios user with rights to monitor and return his key
* `ceph auth get-or-create client.hypervisor mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=volumes'` - create user with enough rights for libvirt to use storage on 'volumes'
* `ceph-authtool -C -n client.hypervisor --gen-key keyring` - name is of type.user format so clients are `client.name`, osds are `osd.0` etc
* `ceph auth list` - list auth
* `ceph auth caps client.hypervisor osd 'allow rw pool=volumes'` - modify permissions for user. `''` for none. You **have to** specify all (mon+osd, or mon+osd+mds), if you dont it will zero out other permissions. So if you change osd perms, copy-paste mon permissions too
* `ceph auth import -i /etc/ceph/client.nagios.keyring` - import a keyring

## Pool management

* `ceph osd pool create volumes 512` - create pool `volumes` with `512` placement groups
* `ceph osd pool set {pool-name} pg_num {pg_num}` - change placement group count (disruptive). Remember to also change pgp_num after that, obsolete, see autoscaler
* `ceph osd pool set {pool-name} pgp_num {pgp_num}` - change placement group for placement count (disruptive). Remember to change pg_num before that
* `ceph pg ls-by-pool {pool-name}`


### PG autoscalling

* `ceph osd pool autoscale-status` will give you state of it. The important part here is "BIAS", that's preferred method of controlling number of PGs per pool
* `ceph osd pool set default.rgw.buckets.index pg_autoscale_bias 16`  - multiply ratio by that number. Which means for big ratios (like `.index` vs `.data`) you might need to use big number to affect placement
* `ceph osd pool set default.rgw.buckets.index pg_num_min 64` - to set minimum - currently you need to resize to that minimum *first* (see manual method) then apply it

#### Manual
* `ceph osd pool set foo pg_autoscale_mode off`
* `ceph osd pool set foo pg_num 64` - create
* `ceph osd pool set foo pgp_num 64` - balance (pgp means "placement groups for placement")

## clients

* `ceph daemon mon.$(hostname -s) sessions |less` - show active sessions on current mon
* `ceph features` - show how many clients use given feature set and client version


## Volume management

* `rbd create mypool/myimage --size 102400` - create 100GB image. THIS IS IN MEGABYTES and it doesnt support usual k/M/G/T suffixes
* `rbd info bd info volumes/volume` - get info about image. `volumes/` is name of the pool, not required if using default
* `rados listwatchers -p volumes rbd_header.27b99c4dd4a60` - get info what is using the image. the ID comes from `rbd_info` block_name_prefix field, just replace `rbd_data` with `rbd_header`


## OSD

* `ceph-osd -i 11 --mkjournal` - initialize journal
* `ceph-osd -i 11 --flush-journal` - flush journal (stop osd service first!)
* `ceph-osd -i 11 --mkfs --mkkey` - create fs and key for osd
* `ceph auth add osd.8  osd 'allow *' mon 'allow rwx' -i /var/lib/ceph/osd/ceph-8/keyring` - add key for osd
* `ceph osd create 2e6ee69a-5477-40b2-9eea-c675ef8ca2a3` - create osd from blkuid
* `ceph-volume lvm list` - show lvm to osd mapping

### Removing OSD

    ceph osd crush reweight osd.{osd-num} 0 # wait for rebalance
    ceph osd out {osd-num}
    ceph osd crush remove osd.{osd-num}
    ceph auth del osd.{osd-num}
    ceph osd rm {osd-num}

### Cleaning up all OSD remains

    umount /var/lib/ceph/osd/*
    for a in `lvs | grep osd-block |grep ceph |awk '{print $2}'` ; do vgremove $a ; done


### Restarting osd

    ceph osd set noout


restart

    ceph osd unset noout
    ceph osd unset norebalance

### osd recovery

* `ceph osd set noin` - do not add new ones automatically
* `ceph osd set nobackfill` - do not start backfill
* `ceph osd set norecover` - do not start recovery


### replacing drive

First, destroy old:

    ceph osd destroy 4

then prepare new

    ceph-volume lvm create --osd-id 4 --data /dev/nvme0n1p5

or in parts

    ceph-volume lvm prepare --osd-id 4 --data /dev/nvme0n1p5
    ceph-volume lvm activate 4 fsid-from-above-command


## pg

* deep scrub:  `ceph pg deep-scrub <pg.id>` to get detail `ceph health detail`


## Rados GW

### Common ops

* `radosgw-admin user create --uid="username" --display-name="long username"`
* `radosgw-admin user rm --uid=username`
* `radosgw-admin bucket list`
* `radosgw-admin metadata get user:testuser`
* `radosgw-admin bi list --bucket=bucketname` - list bucket index

### Create pools
`for a in .rgw.root .rgw.control .rgw.gc .rgw.buckets .rgw.buckets.index .rgw.buckets.extra .log .intent-log .usage .users .users.email .users.swift .users.uid ; do ceph osd pool create $a 16 16 ; done`

will create small (16 PG) pools for RADOS; you can tune up but not down (AFAIK, might be fixed) so it is better to start small


## RBD

### Common ops

* `rbd resize --image pool-name/volume-name --size 115G` - resize in KVM via `virsh blockresize vmname device --size 115G`, device can be just `vdX`
* `rbd --pool volumes ls`

### Writeable snapshot (you NEED it to mount XFS and similar from it)

* `rbd snap ls volumes/<image_name>` - get snapshot name
* `rbd snap protect volumes/<image_name>@<snapshot_name>` - protect it (from removal)
* `rbd clone volumes/<image_name>@<snapshot_name> volumes/<image_name>.snap` - clone it
* `volumes/<image_name>.snap` is now available for use
* `rbd device map volumes/<image_name>.snap --id admin` - map it
* `rbd children volumes/<image_name>@<snapshot_name>` - list snapshot children
* `rbd flatten volumes/<image_name>.snap` - flatten (takes a long time, it's full copy)

## Gotchas

* `ceph osd crush tunables optimal` - run on new cluster to use optimal profile instead of legacy; will cause rebalance


## Random

### Debug

add `types = [ "rbd", 1024 ]` to lvm.conf in device section to make LVM see it


`/sys/kernel/debug/ceph/<cluster-fsid.client-id>/osdc` contains in-flight requests

#### Crash handling

* `ceph crash ls` - to see list
* `ceph crash info <id>` - to see details
* `ceph crash archive-all` - cleanup


ceph osd set-full-ratio 0.95


#### legacy way of balancing

    ceph osd test-reweight-by-utilization
    ceph osd reweight-by-utilization

##### or manually

    ceph osd reweight osd.1 0.8

#### new way

    ceph mgr module enable balancer
    ceph balancer on

##### new balancing mode

    ceph balancer mode upmap

#### manual plan

##### evaluate current one

    ceph balancer eval
    ceph balancer eval-verbose

##### generate new plan

    ceph balancer optimize new-plan
    ceph balancer show new-plan

##### show all plans

    ceph balancer ls
    ceph balancer status

##### remove

    ceph balancer rm new-plan

##### run

    ceph balancer execute

##### change throttling (defaults to 0.05/5%)

    ceph config set mgr mgr/balancer/max_misplaced .07   # 7%

#### recovery

    ceph tell 'osd.*' injectargs '--osd-recovery-max-active 4' #default 3
    ceph tell 'osd.*' injectargs '--osd-max-backfills 16' #default 1


#### find bad PG

    rados list-inconsistent-obj 6.7 --format=json-pretty #0.7 is pg id

#### ????

    ceph osd pool application enable volumes rbd
