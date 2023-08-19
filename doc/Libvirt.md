#### Force ACPI shutdown


Sometimes needed for windows machine

`virsh shutdown --mode acpi machine`



#### Send SysRq

`virsh send-key machine KEY_LEFTALT KEY_SYSRQ KEY_S`


### Migration

* `virsh migrate --copy-storage-all --live --verbose vmname qemu+tls://targethost.example.com/system` - migrate all disks, no shared storage
* `virsh migrate --live --verbose vmname qemu+tls://targethost.example.com/system --migrate-disks vdb` - shared storage, one of disks (`vdb`) is local and needs migration.
