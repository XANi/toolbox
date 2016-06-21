#### Delete "stuck" device

`echo 1 >  /sys/block/sdn/device/delete`


#### Cleanup multipath device

[R](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Online_Storage_Reconfiguration_Guide/removing_devices.html

* `multipath -F` / `multipath -f device` - multipath sometimes requires restart to clean it up; and in case of centos restart does some additional stuff that sometimes makes stuff freeze so stop -> start might be required
* `iscsiadm -m session -R` - after removing LUN from SAN
