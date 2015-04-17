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
* `megacli -PDList -aALL` - list all physical devices and their state on all controllers
* `megacli -PDInfo -PhysDrv '[3:1]' -aALL` - info about single physical drive
* `megacli -PdLocate -Physdrv '[3:1]' -aAL` - locate, add `-stop` to stop
* `megacli -CfgLdAdd -rX[E0:S0,E1:S1,...] -[WT|WB] -[NORA|RA|ADRA] -[Direct|Cached]` - add logical drive
    * `-rX` - raid level
    * `WT|WA` - write-thru/writeback
    * `NORA|RA|ADRA` - read-ahead policy
    * `Direct|Cached` - if cached reads are cached in controller's memory
    * `CachedBadBBU|NoCachedBadBBU` - if writes are still cached when battery is bad
* `megacli -LDInfo  -Lall -a0` - info about all LD on same controller
* `megacli -PDOnline -Physdrv '[3:1]'` - force drive status to online - if you want to do something with disk stuck in Error` state
* `megacli -CfgLdAdd -r0 [3:1] WT NORA Cached -a0` - add closest equivalent to "passthru" on some MegaRAID controllers that can't be flashed into IT mode
* `megacli -PDList -aALL |grep -P -i '(Slot Number|Firmware state|Coerced size|Enclosure device)' |perl -pe 's/Enclosure/\nEnclosure/g' |less` - short status summary
` -
* `megacli -AdpSetProp -AlarmSilence -aALL` - silence current alarm (will still trigger on next)
* `megacli -PDRbld -ShowProg -PhysDrv [3:1] -aALL` - show raid rebuild progress
* `megacli -CfgEachDskRaid0 WT NORA Direct NoCachedBadBBU -aALL` - make a bunch of RAID0s from disks`
### Remove drive

* `megacli -PDOffline -PhysDrv '[252:1]' -a0` - this will make controller make loud noises
* `megacli -PDMarkMissing -PhysDrv '[252:1]' -a0 - this will make controller stop making loud noises
* `megacli -PdPrpRmv -PhysDrv '[252:1]' -a0` this will stop drive

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
