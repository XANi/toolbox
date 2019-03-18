

## Extracting dep info

* `systemctl list-dependencies --before ifup@eno2.service` - shows deps **AFTER** the unit
* `systemctl list-dependencies --after ifup@eno2.service` - shows deps **BEFORE** the unit

## Containers

as of systemd 224, mem limits do not work from user acct, so you need to run that one as root

* `systemd-run --scope --uid username -p MemoryLimit=100M ./some-app` - create cgroup then run app in it. `MemoryLimit` applies **only** to memory so for example setting it to 100MB will make app use 100MB of RAM and then swap the rest
