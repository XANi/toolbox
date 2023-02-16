# RAID cheatsheet

## Software RAID (mdadm)

### Create array

`mdadm --create /dev/md2 --level=1 --raid-devices=2 /dev/sdb2 /dev/sdd2`

* `--spare-devices-` - for number of spares (usually not neccesary to specify that)
* `--assume-clean` - dont run inital sync (not recommended on non-raid1(0)), useful for recovering existing ones
* `--write-mostly` - devices specified after that will be used mostly for writing

### Examine componentdevice

`mdadm --examine`

useful info:

* UUID - for use with scan/assemble
* Events - can check which device was last written as candidate for recovery

### Scan and run existing array

`mdadm --assemble --scan`

add `--uuid=` (from `--examine`) to start only specific one

## resize array

`mdadm -G -z=amount_of_KB`

You can also set -Z to specify "array" size (size visible to application) but that wont persist between reboots


## make RAID10 out of RAID online

* shrink PV - `pvresize --setphysicalvolumesize 20G /dev/md1`
* change device and array size - `mdadm /dev/md1 -G  -z 25G -Z 25`
* change to RAID0 (unsafe) - `mdadm /dev/md1 -G  -l 0`
* change to RAID10 and re-add disk - `mdadm /dev/md1 -G  -l 10 --add /dev/sda2`
* add remaining disk(s) - `mdadm /dev/md1 --add /dev/sdc2`
* grow array back - ` mdadm -G /dev/md1 --raid-devices=4`

## shrinking raid

sometimes backup of sector is required:

    mdadm --grow --raid-devices=10 /dev/md127 --backup-file /root/md127.backup

message is usually sth like



## Generate mdadm.conf

`mdadm --detail --scan`

    mdadm: Cannot set new_offset for /dev/sdn1


## [MegaRAID](http://www.lsi.com/Search/pages/results.aspx?k=megacli&r=assettype%3D%22AQpVc2VyIEd1aWRlCWFzc2V0dHlwZQECXiICIiQ%3D%22)

Devices are addressed by enclosure ID and their number in that enclosure. So device reported as:

    Enclosure Device ID: 252
    Slot Number: 1
    Device Id: 38

have to be addressed by `[252:1]`
Naming:
* **PD** - Physical Drive
* **LD** - Logical Drive

### Full event log ###

#### array/controller info

* `megacli -AdpAlILog -a0` - full log. Long. Very long and slow.
* `megacli -AdpAllInfo -a0` - all info
* `megacli -PDList -aALL` - list all physical devices and their state on all controllers
* `megacli -PDInfo -PhysDrv '[3:1]' -aALL` - info about single physical drive
* `megacli -LDInfo  -Lall -a0` - info about all LD on same controller
* `megacli -LdPdInfo -aAll` - info about each LD followed by its PDs
* `megacli -PdLocate -Physdrv '[3:1]' -aAL` - locate, add `-stop` to stop

#### Basic ops

* `megacli -CfgLdAdd -rX[E0:S0,E1:S1,...] -[WT|WB] -[NORA|RA|ADRA] -[Direct|Cached]` - add logical drive
    * `-rX` - raid level
    * `WT|WA` - write-thru/writeback
    * `NORA|RA|ADRA` - read-ahead policy
    * `Direct|Cached` - if cached reads are cached in controller's memory
    * `CachedBadBBU|NoCachedBadBBU` - if writes are still cached when battery is bad
* `megacli -CfgClr -aALL` - **CLEAR ALL CONFIG OF EVERYTHING**
* `megacli -CfgForeign -Clear -aALL` - clear config of foreign (marked `Foreign State: Foreign` in PD info)
* `megacli -PDOnline -Physdrv '[3:1]'` - force drive status to online - if you want to do something with disk stuck in `Error` state
* `megacli -CfgLdAdd -r0 [3:1] WT NORA Cached -a0` - add closest equivalent to "passthru" on some MegaRAID controllers that can't be flashed into IT mode
* `megacli -LdPdInfo -aAll |grep -P -i '(Slot Number|Firmware state|Coerced size|Enclosure device|Slot|Virtual Drive|Inquiry)' |perl -pe 's/Virtual/\nVirtual/g'`
* `megacli -EncInfo -aALL` - enclosure info
* `megacli -AdpBbuCmd -aALL` - battery info
* `megacli -AdpSetProp -AlarmSilence -aALL` - silence current alarm (will still trigger on next)
* `megacli -PDRbld -ShowProg -PhysDrv [3:1] -aALL` - show raid rebuild progress
* `megacli -adpsetprop -enablejbod -1 -a0` - JBOD disks (works on LSI 2208, **doesnt** on 2108)
    it should detect your drives right after you ran command, it only touches unconfigured drives so you might want to clear config first
    Also, IBM BIOS can be retarded about it and sometimes you need to set boot device to **Legacy** to have bootable system
* `megacli -CfgEachDskRaid0 WT NORA Direct NoCachedBadBBU -aALL` - make a bunch of RAID0s from disks. You probably want JBOD mode  if possible (2108 will return ok but fail)
* `megacli -LDSetProp -ForcedWB -Immediate -LALL -a0` - force writeback, needed on flash-based cache unit

#### Boot manager

* `megacli -AdpBootDrive -Get -a0` -  get boot drive
    Adapter 0: Boot Physical Drive -- EnclId- 10 Slotid - 1.

    Exit Code: 0x00
* `megacli -AdpBootDrive -Set -physdrv '[10:1]' -a0` - set boot drive to physical (like JBOD) volume
* `megacli -AdpBootDrive -Set -L0 -a0` - set boot drive to logical volume


### Remove drive

* `megacli -PDOffline -PhysDrv '[252:1]' -a0` - this will make controller make loud noises
* `megacli -PDMarkMissing -PhysDrv '[252:1]' -a0` - this will make controller stop making loud noises
* `megacli -PdPrpRmv -PhysDrv '[252:1]' -a0` this will stop drive

### clear drive

remove config and start disk clear

* `megacli -CfgClr -aALL` - clear all config
* `megacli -PDClear -Start -PhysDrv [252:3] -a0` - start clear on device 252:3 (change to `-Stop` to stop)
* `megacli -PDClear -ShowProg -PhysDrv [252:2] -a0` - show progress

### clear disk cache

 "The current operation is not allowed because the controller has data in cache for offline or missing virtual disks"

* `megacli -GetPreservedCacheList -aALL`

        Adapter #0

        Virtual Drive(Target ID 01): Missing.

        Exit Code: 0x00

* `megacli -DiscardPreservedCache -L1 -aALL`

        Adapter #0

        Virtual Drive(Target ID 01): Preserved Cache Data Cleared.

        Exit Code: 0x00


### flashing

* get firmware
* `megacli -adpfwflash -f mr2208fw.rom -a0`

## ServeRAID

### Get array status
* `arcconf GETCONFIG 1` - dump of full config with logical and physical drives
* `arcconf GETLOGS 1 DEVICE` - device errors:

        Controllers found: 1
        <ControllerLog controllerID="0" type="0" time="1421660883" version="1" tableFull="false">
            <driveErrorEntry adapterID="0" channelID="0" deviceID="3" slotNum="3" enclIndex="0" numParityErrors="0" linkFailures="0" hwErrors="1" abortedCmds="0" mediumErrors="0"/>
            <driveErrorEntry adapterID="0" channelID="0" deviceID="0" slotNum="0" enclIndex="0" numParityErrors="0" linkFailures="0" hwErrors="2" abortedCmds="0" mediumErrors="0"/>
            <driveErrorEntry adapterID="0" channelID="0" deviceID="2" slotNum="2" enclIndex="0" numParityErrors="0" linkFailures="0" hwErrors="0" abortedCmds="0" mediumErrors="7"/>
        </ControllerLog>

* `arcconf GETLOGS 1 EVENT` - event log

        Controllers found: 1
            <ControllerLog controllerID="0" type="0" time="1421660883" version="1" tableFull="false">
                <driveErrorEntry adapterID="0" channelID="0" deviceID="3" slotNum="3" enclIndex="0" numParityErrors="0" linkFailures="0" hwErrors="1" abortedCmds="0" mediumErrors="0"/>
                <driveErrorEntry adapterID="0" channelID="0" deviceID="0" slotNum="0" enclIndex="0" numParityErrors="0" linkFailures="0" hwErrors="2" abortedCmds="0" mediumErrors="0"/>
                <driveErrorEntry adapterID="0" channelID="0" deviceID="2" slotNum="2" enclIndex="0" numParityErrors="0" linkFailures="0" hwErrors="0" abortedCmds="0" mediumErrors="7"/>
            </ControllerLog>
            ...

### Add hotspare
`arcconf setstate 1 device 0,1 hsp logicaldrive 0`
