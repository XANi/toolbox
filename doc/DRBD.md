# DRBD

```
drbdadm create-md datafs
drbdadm attach datafs
drbdadm --  --overwrite-data-of-peer primary datafs # only on one node
```
