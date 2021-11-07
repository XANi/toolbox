

### Corosync

  * `corosync-cfgtool -s` - display status of connections


### PCS

  * `pcs resource move resourcename node`
  * `pcs resource ban resourcename node`
  * `pcs resource clear resourcename` - clear temporary move/ban


  * `pcs property set maintenance-mode=true`
  * `pcs property unset maintenance-mode` or `pcs property set maintenance-mode=false`
