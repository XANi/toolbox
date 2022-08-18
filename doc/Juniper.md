* `show route advertising-protocol bgp 1.1.1.1` - show routes advertised to host
* `show route receive-protocol bgp 1.1.1.1` - show routes received from host

#### Add default gw for management

    `set routing-options static route 0.0.0.0/0 next-hop 172.16.1.1`
    `set routing-options static route 0.0.0.0/0 no-readvertise`


## reorder terms
    `insert term drop-mgmt before term export-connected` - move `drop-mgmt` before `export-connected` term

## show config after inheritance
    `show |display inheritance`


## Traffic monitoring

`monitor traffic detail interface sth`

* `matching "sth"` to limit traffi
* `write-file asd` to write to file. Do NOT fuck up with it, you dont want to fill disks

## SNMP on route-instance

SNMP on route-instance or logical-system requires prefixing, so `public` -> `default@public`, route instance `mgmt` -> `mgmt@public` and logical system `core` -> `core/default@public`

example config:

    set snmp community public authorization read-only
    set snmp community public routing-instance mgmt clients 192.168.1.1/32
    set snmp community public logical-system mgmt routing-instance default clients 192.168.1.1/32
    set snmp routing-instance-access

it also doesnt seem to like querying another logical system from non-default routing instance

### SNMP restart

    `restart snmp gracefully`

### Display resolved prefix list
run show configuration policy-options prefix-list bgp-peers |display inheritance

## Route preference

| Source | Preference | Description|
|--------|------------|------------|
|Local |0 | Local IP of the interface|
|Directly connected network | 0 | Subnet of directlu connected interface|
|System| 4 | Routes installed by Junos
|Static| 5 | Static routes
|RSVP| 7 | Routes learned from RRP used in MPLS
|LDP| 9 | Routes learned from LDP used in MPLS
|OSPF internal route| 10 | OSPF internal routes like interfaces running OSPF|
|IS-IS L1 internal route | 15 | IS-IS internal routes like interfaces running IS-IS |
|IS-IS L2 internal route | 18 | IS-IS internal routes like interfaces running IS-IS |
|ICMP Redirect | 30 | Routes from ICMP redirects|
|Kernel | 40 | Routes via route socket from kernel |
|SNMP | 50 | Routes installed from SNMP |
|Router discovery | 55 | ICMP Router discovery |
|RIP| 100 | Routes from RIP |
|RIPng| 100 | Routes from RIPng |
|PIM| 105 | Router from PIM |
|DVMRP | 110 | Routes from Distance Vector Multicast |
|Aggregate | 130 | Aggregate and generated |
|OSPF AS external route | 150 | Routes from OSPF that have been redistributed into it |
|IS-IS L1 external route| 160 | Routes from IS-IS that have been redistributed into it |
|IS-IS L2 external route| 160 | Routes from IS-IS that have been redistributed into it |
|BGP | 170  | Routes from BGP|
|MSDP | 175 | Routes from Multicast Source Discovery Protocol|
