## Upgrade

* `pg_dumpall|pv |pigz --fast -c > /var/lib/pgsql/dump-$(date "+%F").sql.gz` - dump db, skip pigz if you have plenty of space

## Resync slave
* `export LD_LIBRARY_PATH=/usr/pgsql-9.4/lib/`
* `./pg_basebackup -D /var/lib/pgsql/9.4/data -h  1.2.3.4 -R -xlog-method=stream -v`
