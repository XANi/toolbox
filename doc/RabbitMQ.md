### Adding cluster node
# rabbitmqctl stop_app
Stopping node rabbit@rabbit2 ...done.
# rabbitmqctl join_cluster rabbit@rabbit1
Clustering node rabbit@rabbit2 with [rabbit@rabbit1] ...done.
# rabbitmqctl start_app
Starting node rabbit@rabbit2 ...done.

### Removing cluster node

* `rabbitmqctl forget_cluster_node  rabbit@rabbit2-cluster` - if it is running
