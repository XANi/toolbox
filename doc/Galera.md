# Install

## Init db

If empty data dir, on first node (must have empty `/var/lib/mysql` and `/var/lib/mysql/tmp`:

    mysql_install_db
    /etc/init.d/mysqld bootstrap-pxc
    /usr/bin/mysqladmin -u root password 'cluster-root-password'

on rest ( **CONNECTING TO RUNNING CLUSTER WILL WIPE THE DATA ON CONNECTING NODE!!!** ):

    mysql_install_db # if required
    /etc/init.d/mysqld start
