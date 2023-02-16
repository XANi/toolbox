`pacmd list-sinks` to list name or index number of possible sinks

`pacmd set-default-sink "SINKNAME"` to set the default output sink

`pacmd set-default-source "SOURCENAME"` to set the default input


Note: Changing the output sink through the command line interface can only take effect if stream target device reading is disabled. This can be done by editing the corresponing line in /etc/pulse/default.pa to:

`load-module module-stream-restore restore_device=false`


## Remapping stereo channel into 2 mono ones

First, get the name of device from `pacmd list-sources`

    ...
     * index: 2
	name: <alsa_input.usb-BEHRINGER_UMC204HD_192k-00.analog-stereo>
	driver: <module-alsa-card.c>
	flags: HARDWARE HW_MUTE_CTRL HW_VOLUME_CTRL DECIBEL_VOLUME LATENCY DYNAMIC_LATENCY
	state: RUNNING
	suspend cause: (none)
	priority: 9049
	volume: front-left: 65536 / 100% / 0.00 dB,   front-right: 65536 / 100% / 0.00 dB
	        balance 0.00
	base volume: 65536 / 100% / 0.00 dB
	volume steps: 65537
	muted: no
	current latency: 0.59 ms
	max rewind: 0 KiB
	sample spec: s32le 2 k 44100 Hz
	channel map: front-left,front-right

then look at channel spec and map them to 2 separate mono channels

    pacmd load-module module-remap-source source_name=UMC204HD_in1 master=alsa_input.usb-BEHRINGER_UMC204HD_192k-00.analog-stereo channel_map=mono master_channel_map=front-left source_properties="device.description='UMC204HD\ input\ 1'"
    pacmd load-module module-remap-source source_name=UMC204HD_in2 master=alsa_input.usb-BEHRINGER_UMC204HD_192k-00.analog-stereo channel_map=mono master_channel_map=front-right source_properties="device.description='UMC204HD\ input\ 2'"
    pacmd set-default-source UMC204HD_in1
