### Key management

* `ceph auth get-or-create client.nagios mon 'allow r'` - create nagios user with rights to monitor and return his key
* `ceph auth get-or-create client.hypervisor mon 'allow r' osd 'allow class-read object_prefix rbd_children, rwx pool=volumes'` - create user with enough rights for libvirt to use storage on 'volumes'
* `ceph-authtool -C -n client.hypervisor --gen-key keyring` - name is of type.user format so clients are `client.name`, osds are `osd.0` etc
* `ceph auth list` - list auth

### Pool management

* `ceph osd pool create volumes 512` - create pool `volumes` with `512` placement groups
* `ceph osd pool set {pool-name} pg_num {pg_num}` - change placement group count (disruptive). Remember to also change pgp_num after that
* `ceph osd pool set {pool-name} pgp_num {pgp_num}` - change placement group for placement count (disruptive). Remember to change pg_num before that
