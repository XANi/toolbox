

## Corosync

  * `corosync-cfgtool -s` - display status of connections

### Quorum
  * `pcs quorum status`
  * `pcs quorum device status`

## PCS

  * `pcs resource move resourcename node`
  * `pcs resource ban resourcename node`
  * `pcs resource clear resourcename` - clear temporary move/ban


  * `pcs property set maintenance-mode=true`
  * `pcs property unset maintenance-mode` or `pcs property set maintenance-mode=false`


### show score

   `crm_simulate -sL`


### manually confirm fence

  * `fence_ack_manual app-srv2` - it's kinda broken and rarely works...

### show pingd/pingouts state

```
:~☠ pcs cluster cib |grep pingd
         <expression id="location-postgresql-rule-expr" operation="gt" attribute="pingd" value="1"/>
          <nvpair id="status-1-pingd" name="pingd" value="1000"/>
          <nvpair id="status-2-pingd" name="pingd" value="1000"/>
```


## Fencing

### Multiple levels

levels are used from from lowest to highest

    pcs -f stonith_cfg stonith create ipmi-fence-sql1-shared fence_ipmilan pcmk_host_list="db-sql1" ipaddr=10.0.0.1 login=fence passwd=xxx lanplus=on power_timeout=10 method=cycle op monitor interval=600s
    pcs -f stonith_cfg stonith create ipmi-fence-sql2-shared fence_ipmilan pcmk_host_list="db-sql2" ipaddr=10.0.0.2 login=fence passwd=xxx lanplus=on power_timeout=10 method=cycle op monitor interval=600s
    pcs -f stonith_cfg stonith create ipmi-fence-sql1-dedicated fence_ipmilan pcmk_host_list="db-sql1" ipaddr=172.16.0.1 login=fence passwd=xxx lanplus=on power_timeout=10 method=cycle op monitor interval=600s
    pcs -f stonith_cfg stonith create ipmi-fence-sql2-dedicated fence_ipmilan pcmk_host_list="db-sql2" ipaddr=172.16.0.2 login=fence passwd=xxx lanplus=on power_timeout=10 method=cycle op monitor interval=600s
    pcs -f stonith_cfg stonith level add 1 db-sql1 ipmi-fence-sql1-dedicated
    pcs -f stonith_cfg stonith level add 2 db-sql1 ipmi-fence-sql1-shared
    pcs -f stonith_cfg stonith level add 1 db-sql2 ipmi-fence-sql2-dedicated
    pcs -f stonith_cfg stonith level add 2 db-sql2 ipmi-fence-sql2-shared
