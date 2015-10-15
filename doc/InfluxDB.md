

## Continuous queries

### Downsample data with some added stats

    select min(value), max(value), mean(value) as value, percentile(95, value) as pct_95, stddev from /^[a-zA-Z].*/ group by time(10m) into 10m.:series_name

## Average multiple data series into one

    select  mean(value) from /dc1..*.ipmi.temperature.Ambient_Temp_front_panel_board.*/ where  time > now() - 24h and value > 10 group by time
