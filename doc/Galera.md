# Bootstrap/restart

**First node up should be last node down** if performing controlled shutdown

Starting cluster from scratch:

* Galera cluster will not run if there is no node to connect to.
* First node have to be booted with `/etc/init.d/mysqld bootstrap-pxc`
* Start other nodes one by one and wait till it goes into synchronized state ( `show status like 'wsrep_%'` should return `wsrep_cluster_status | Primary` )

# Install

## Init db

If empty data dir, on first node (must have empty `/var/lib/mysql` and `/var/lib/mysql/tmp`:

    mysql_install_db
    /etc/init.d/mysqld bootstrap-pxc
    /usr/bin/mysqladmin -u root password 'cluster-root-password'

on rest ( **CONNECTING TO RUNNING CLUSTER WILL WIPE THE DATA ON CONNECTING NODE!!!** ):

    mysql_install_db # if required
    /etc/init.d/mysqld start



# Gotchas

* MyISAM tables **WILL NOT BE REPLICATED** (including mysql database, so user have to be created on each server), only schemas
* Transactions *can* conflict between servers and it will result in one of them getting aborted/rollbacked. App should support retry.
