# BIRD

Commands can be shortcuted as long as they are unique; `show ospf neighbors` is same as `sh os n`. `birdc` takes a command from ARGV if present

## Routes

* `show route` - all routes
* `show route for a.b.c.d` - show available routes to target
* `show route for a.b.c.d primary` - show only primary route to target
* `show route primary` - show only primary routes
* `show route where net ~ 192.168.0.0/16` - show routes matching filter - useful for testing conditions

## OSPF

Ripepd out from cli help, nothing more to say here
Most of these accept instance and interface (if applicable) in `instance "interface"` format, like `show ospf neighbors main "eth1"`

* `show ospf` - show summary of all instances
* `show ospf main` - show ospf instance named "main
* `show ospf interface` - show information about interface
* `show ospf lsadb`     - show content of OSPF LSA database
* `show ospf neighbors` - show information about OSPF neighbors
* `show ospf state`     - show information about OSPF network state
* `show ospf topology`  - show information about OSPF network topology

### OSPF external route type selection

https://bird.network.cz/pipermail/bird-users/2009-October/005606.html

* If just ospf_metric1 is set, route becomes E1.
* If just ospf_metric2 is set, route becomes E2.
* If nothing is set, E2 with ospf_metric2 = 10000 is the default.
* If both are set (uninteresting corner case), ospf_metric2 is ignored.


## Filters

* `if net = 0.0.0.0/0 then krt_prefsrc = 1.2.3.4` -  override kernel source ip ( `krt_prefsrc` ) for certain routes. There is a ton more [here](http://bird.network.cz/?get_doc&f=bird-6.html#ss6.6), every tcp parameter can be overriden.
