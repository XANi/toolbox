

# interface types
## VLAN
   `ip link add link eth0 name eth0.100 type vlan id 100`


# netns

`ip netns add testns`
`ip netns list`
`ip link set eth1 netns testns`
`ip netns exec testns bash`


# Misc

## delete bond from system

    echo -eth3 > /sys/class/net/bond0123/bonding/slaves
    echo -bond0123 > /sys/class/net/bonding_masters


## add multihop route

    ip route add 1.2.3.4/32 scope global \
    nexthop via 10.100.100.1 weight 1 \
    nexthop via 10.100.101.1 weight 1
