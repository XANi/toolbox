## Disk usage
```
 SELECT table,
       formatReadableSize(sum(bytes_on_disk)) AS disk,
       formatReadableSize(sum(data_uncompressed_bytes)) AS uncompressed,
       round(sum(data_uncompressed_bytes)/sum(bytes_on_disk),1) AS ratio
FROM system.parts
WHERE active
GROUP BY table
ORDER BY sum(bytes_on_disk) DESC;

SELECT
    `table`,
    formatReadableSize(sum(bytes_on_disk)) AS disk,
    formatReadableSize(sum(data_uncompressed_bytes)) AS uncompressed,
    round(sum(data_uncompressed_bytes) / sum(bytes_on_disk), 1) AS ratio
FROM system.parts
WHERE active
GROUP BY `table`
ORDER BY sum(bytes_on_disk) DESC
```

by database:

```
SELECT table,
       formatReadableSize(sum(bytes_on_disk)) AS disk,
       formatReadableSize(sum(data_uncompressed_bytes)) AS uncompressed,
       round(sum(data_uncompressed_bytes)/sum(bytes_on_disk),1) AS ratio
FROM system.parts
WHERE active
GROUP BY table
ORDER BY sum(bytes_on_disk) DESC;SELECT database,
       table,
       formatReadableSize(sum(bytes_on_disk))            AS disk,
       formatReadableSize(sum(data_uncompressed_bytes))  AS uncompressed,
       round(sum(data_uncompressed_bytes) / sum(bytes_on_disk), 1) AS ratio,
       sum(rows)                                         AS rows
FROM system.parts
WHERE active
GROUP BY database, table
ORDER BY database ASC,
         sum(bytes_on_disk) DESC;
``
