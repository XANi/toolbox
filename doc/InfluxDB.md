

## Continuous queries

`select min(value), max(value), mean(value) as value, percentile(95, value) as pct_90, stddev from /^[a-zA-Z].*/ group by time(10m) into 10m.:series_name`
