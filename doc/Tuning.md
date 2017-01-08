
### Tuning scheduler


* `/proc/sys/kernel/sched_migration_cost_ns` - how much time process can spend on core before kernel will consider migrating it again, consider increasing.
* `kernel.sched_autogroup_enabled=0` - group processes by tty. [bad for postgres](https://www.postgresql.org/message-id/50E4AAB1.9040902@optionshouse.com)
