## Stop Cisco from raping your DNS request by default

Some model/firmare (like Cisco ISR) rewrite DNS requests to local server by default when NATing.
To avoid that idiocy add

    no ip nat service alg udp dns
    no ip nat service alg tcp dns


## Ospf

* `clear ip ospf process` restart OSPF process, it can hang with older versions
* `router ospf 9` -> `maximum-paths 8` bump max path from 4
