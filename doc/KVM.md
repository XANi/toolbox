#### resize iscsi device

* `iscsiadm -m session -R`
* `multipathd -k"resize multipath <multipath_name>"`
* `virsh qemu-monitor-command <vm_name> --hmp "info block"`
* `virsh qemu-monitor-command <vm_name> --hmp "block_resize drive-virtio-disk2 500G"`


#### install debian
    virt-install --name debian8 \
        --ram 2048 \
        --disk path=/dev/rootvg/vm-pkgbuilder \
        --vcpus 2 \
        --os-type linux \
        --os-variant generic \
        --network bridge=br0 \
        --graphics none \
        --console pty,target_type=serial \
        --location 'http://ftp.pl.debian.org/debian/dists/jessie/main/installer-amd64/' \
        --extra-args 'console=ttyS0,115200n8 serial'
