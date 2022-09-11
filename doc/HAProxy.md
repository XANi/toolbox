


#### Snippets

### Log old TLS

```
    http-request capture req.hdr(User-Agent) len 100
    acl good-tls ssl_fc_protocol eq TLSv1.3
    acl good-tls ssl_fc_protocol eq TLSv1.2
    http-request set-log-level notice if { ssl_fc } !good-tls
```
