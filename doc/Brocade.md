## ICX

* packet capture:

    debug packet-capture filter none # clear all filters
    debug packet-capture filter 1 in-port 2/1/26 # select port, l2/3 filters also exit
    debug packet-capture max 50 # stop capture after 50 packets
    debug packet-capture mode brief # there is also pcap format, see `?`
    debug packet-capture # starts capture
