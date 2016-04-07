 ad## ICX

* packet capture:

        debug packet-capture filter none # clear all filters
        debug packet-capture filter 1 in-port 2/1/26 # select port, l2/3 filters also exit
        debug packet-capture max 50 # stop capture after 50 packets
        debug packet-capture mode brief # there is also pcap format, see `?`
        debug packet-capture # starts capture, running again or waiting for 50 packets stops
        no debug all # stops any debug

* 802.1x

        show mac-authentication sessions all






* firmware update(tested on 6430)

        copy tftp flash 192.168.251.34 /icx-08.03.0f/ICX64xx/Boot/kxz10105.bin bootrom
        copy tftp flash 192.168.251.34 /icx-08.03.0f/ICX64xx/Images/ICX64S08030f.bin primary
!
* cable test

        telnet@switch-g#phy cable-diagnostics tdr 1/1/15
        (... wait for a minute ...)
        telnet@switch-g#show cable-diagnostics tdr 1/1/15

        Port	Speed	Local pair	Pair Length	Remote pair	Pair status
        ----	-----	----------	-----------	-----------	-----------
        1/1/15 	UNKWN	Pair A    	0000015M   	          	Open
            	     	Pair B    	0000016M   	          	Open
            	     	Pair C    	0000016M   	          	Open
            	     	Pair D    	0000015M   	          	Open

## VDX

### change airflow direction

brocade needs that to match plugged in power supplies, else it wont start fans.
From non-configure mode:

    chassis fan airflow-direction port-side-exhaust

or `port-side-intake`


## CER

`clear ip bgp neighbor x.y.z.v/AS`
`show ip bgp neighbors z.y.x.v advertised-routes`
