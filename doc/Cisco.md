## Stop Cisco from raping your DNS request by default

Some model/firmare (like Cisco ISR) rewrite DNS requests to local server by default when NATing.
To avoid that idiocy add

    no ip nat service alg udp dns
    no ip nat service alg tcp dns
