

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
