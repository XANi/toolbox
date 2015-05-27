### _cat interface

Es provides various useful info under /_cat/ namespaces like that:

    ~ᛯ curl  localhost:9200/_cat/nodes
    dev14.non.3dart.com 127.0.0.1 47 42 2.04 d m dev14 [ ex-cluste ]
    dev13.non.3dart.com 127.0.0.1 71 48 0.77 d m dev13 [ ex-cluste ]
    dev09.non.3dart.com 127.0.0.1 57 49 1.31 d m dev09 [ ex-cluste ]
    dev11.non.3dart.com 127.0.0.1 63 50 0.86 d * dev11 [ ex-cluste ]
    dev10.non.3dart.com 127.0.0.1 56 47 1.08 d m dev10 [ ex-cluste ]
    dev12.non.3dart.com 127.0.0.1 56 42 0.68 d m dev12 [ ex-cluste ]


Adding '?v' will add colum names + padding, like that:

    ~ᛯ curl  localhost:9200/_cat/nodes?v
    host                   ip        heap.percent ram.percent load node.role master name
    dev14.non.3dart.com 127.0.0.1           46          42 1.78 d         m      dev14 [ ex-cluste ]

* [`/_cat/`](http://localhost:9200/_cat/?v) - index of all cats
* [`/_cat/allocation`](http://localhost:9200/_cat/allocation?v) - disk space/shard allocation summary
* [`/_cat/shards`](http://localhost:9200/_cat/shards?v) - list of all shards and their replicas
* [`/_cat/shards/{index}`](http://localhost:9200/_cat/shards/{index}?v) - list of shards belonging to index
* [`/_cat/master`](http://localhost:9200/_cat/master?v) - master node
* [`/_cat/nodes`](http://localhost:9200/_cat/nodes?v) - all nodes
* [`/_cat/indices`](http://localhost:9200/_cat/indices?v) - health and summary of all indices
* [`/_cat/indices/{index}`](http://localhost:9200/_cat/indices/{index}?v) - health and summary of one indice
* [`/_cat/segments`](http://localhost:9200/_cat/segments?v) - internal data about lucene stuff
* [`/_cat/segments/{index}`](http://localhost:9200/_cat/segments/{index}?v) - internal data about lucene stuff
* [`/_cat/recovery`](http://localhost:9200/_cat/recovery?v) - state of recovery
* [`/_cat/recovery/{index}`](http://localhost:9200/_cat/recovery/{index}?v) - state of recovery for one index
* [`/_cat/health`](http://localhost:9200/_cat/health?v) - health + some basic data
* [`/_cat/pending_tasks`](http://localhost:9200/_cat/pending_tasks?v) - tasks
* [`/_cat/aliases`](http://localhost:9200/_cat/aliases?v) - aliases
* [`/_cat/aliases/{alias}`](http://localhost:9200/_cat/aliases/{alias}?v) - one alias
* [`/_cat/thread_pool`](http://localhost:9200/_cat/thread_pool?v) - count of active threads in pool
* [`/_cat/plugins`](http://localhost:9200/_cat/plugins?v) - installed plugins