## Upgrade

* `pg_dumpall|pv |pigz --fast -c > /var/lib/pgsql/dump-$(date "+%F").sql.gz` - dump db, skip pigz if you have plenty of space

## Resync slave
* `export LD_LIBRARY_PATH=/usr/pgsql-9.4/lib/`
* `./pg_basebackup -D /var/lib/pgsql/9.4/data -h  1.2.3.4 -R -xlog-method=stream -v`


## show DB size

approximate

    SELECT d.datname AS Name,  pg_catalog.pg_get_userbyid(d.datdba) AS Owner,
        CASE WHEN pg_catalog.has_database_privilege(d.datname, 'CONNECT')
            THEN pg_catalog.pg_size_pretty(pg_catalog.pg_database_size(d.datname))
            ELSE 'No Access'
        END AS SIZE
    FROM pg_catalog.pg_database d
        ORDER BY
        CASE WHEN pg_catalog.has_database_privilege(d.datname, 'CONNECT')
            THEN pg_catalog.pg_database_size(d.datname)
            ELSE NULL
        END DESC -- nulls first
        LIMIT 20;
