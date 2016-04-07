

# interface types
## VLAN
   `ip link add link eth0 name eth0.100 type vlan id 100`


# netns

`ip netns add testns`
`ip netns list`
`ip link set eth1 netns testns`
`ip netns exec testns bash`
