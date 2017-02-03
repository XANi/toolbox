`pacmd list-sinks` to list name or index number of possible sinks

`pacmd set-default-sink "SINKNAME"` to set the default output sink

`pacmd set-default-source "SOURCENAME"` to set the default input


Note: Changing the output sink through the command line interface can only take effect if stream target device reading is disabled. This can be done by editing the corresponing line in /etc/pulse/default.pa to:

`load-module module-stream-restore restore_device=false`
