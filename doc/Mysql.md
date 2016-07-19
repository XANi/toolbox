* `SET PASSWORD FOR ''@'' = PASSWORD('');`
* ` flush privileges;`

`CREATE USER 'testuser'@'%' IDENTIFIED BY 'pass';
`GRANT ALL PRIVILEGES ON testdb.* TO testuser'@'%' WITH GRANT OPTION;
