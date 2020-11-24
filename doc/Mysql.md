* `SET PASSWORD FOR ''@'' = PASSWORD('');`
* ` flush privileges;`

`CREATE USER 'testuser'@'%' IDENTIFIED BY 'pass';
`GRANT ALL PRIVILEGES ON testdb.* TO testuser'@'%' WITH GRANT OPTION;



## Galera

### Reviving cluster with broken quorum

Need at least one node alive, else you can pass bootstap like usual from commandline

* Find most advanced node: `SHOW STATUS LIKE 'wsrep_last_committed';`
* Switch it to bootstrap mode `SET GLOBAL wsrep_provider_options='pc.bootstrap=YES';
* Restart remaining nodes one by one
