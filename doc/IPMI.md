* `ipmitool -A MD5 -U Administrator -I lan -H 172.16.255.41 -U USERID chassis status`

Those should in *theory* make your server boot into bios on next reboot... in practice fuck you IBM

* `ipmitool chassis bootdev bios` - set "next boot device" to bios. Usually does not work. Try next one
* `ipmitool chassis bootparam set bootflag force_bios` - chassis off before that, chassis on after
* `ipmitool chassis bootparam set bootflag force_pxe`- force pxe

* `ipmitool mc watchdog get` - get watchdog status


## Add user

* `ipmitool user set name 3 fence`
* `ipmitool user set password 3`
* `ipmitool channel setaccess 1 3 link=on ipmi=on callin=on privilege=4`
* `ipmitool user enable 3`
