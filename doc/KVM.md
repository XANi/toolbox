#### resize iscsi device

* `iscsiadm -m session -R`
* `multipathd -k"resize multipath <multipath_name>"`
* `virsh qemu-monitor-command <vm_name> --hmp "info block"`
* `virsh qemu-monitor-command <vm_name> --hmp "block_resize drive-virtio-disk2 500G"`
