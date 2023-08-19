## Stop Cisco from raping your DNS request by default

Some model/firmare (like Cisco ISR) rewrite DNS requests to local server by default when NATing.
To avoid that idiocy add

    no ip nat service alg udp dns
    no ip nat service alg tcp dns


## Ospf

* `clear ip ospf process` restart OSPF process, it can hang with older versions
* `router ospf 9` -> `maximum-paths 8` bump max path from 4

## tunnel detail

* `show crypto session detail` show ssl sessions


## route capacity info

* `show platform hardware ip route summary`


## Nexus

### VLAN

https://www.cisco.com/c/en/us/td/docs/switches/datacenter/nexus9000/sw/7-x/interfaces/configuration/guide/b_Cisco_Nexus_9000_Series_NX-OS_Interfaces_Configuration_Guide_7x/b_Cisco_Nexus_9000_Series_NX-OS_Interfaces_Configuration_Guide_7x_chapter_0101.html

    switch# configure terminal
    switch(config)# interface ethernet 2/1.1
    switch(config-if)# ip address 192.0.2.1/8
    switch(config-if)# encapsulation dot1Q 33
