##Setting up network for capture

* set MTU to biggest your card can support (else it will complain about truncated packets)
* disable any kind of offloading:

    ethtool -K eth2 tso off
    ethtool -K eth2 gro off
    ethtool -K eth2 ufo off
    ethtool -K eth2 lro off
    ethtool -K eth2 gso off
    ethtool -K eth2 rx off
    ethtool -K eth2 tx off
    ethtool -K eth2 sg off
    ethtool -K eth2 rxvlan off
    ethtool -K eth2 txvlan off
    ethtool -N eth2 rx-flow-hash udp4 sdfn
    ethtool -N eth2 rx-flow-hash udp6 sdfn
    ethtool -C eth2 rx-usecs 1 rx-frames 0
    ethtool -C eth2 adaptive-rx off
