
## Inspect device

wpctl status

wpctl inspect [ID]

  * node.name = "alsa_output.usb-BEHRINGER_UMC204HD_192k-00.Direct__Direct__sink"



## make stereo into mono, 4.0 into stereo

put in `~/.config/pipewire/pipewire.conf.d/10-split.conf`

```
context.modules = [
    {   name = libpipewire-module-loopback
        args = {
            node.description = "UMC204HD IN 1"
            capture.props = {
                node.name = "UMC204HD IN 1"
                audio.position = [ FL ]
                stream.dont-remix = true
                target.object = "alsa_input.usb-BEHRINGER_UMC204HD_192k-00.Direct__Direct__source"
                node.passive = true
            }
            playback.props = {
                node.name = "UMC204HD IN 1"
                media.class = "Audio/Source"
                audio.position = [ MONO ]
            }
        }
    }
    {   name = libpipewire-module-loopback
        args = {
            node.description = "UMC204HD IN 2"
            capture.props = {
                node.name = "UMC204HD IN 2"
                audio.position = [ FR ]
                stream.dont-remix = true
                target.object = "alsa_input.usb-BEHRINGER_UMC204HD_192k-00.Direct__Direct__source"
                node.passive = true
            }
            playback.props = {
                node.name = "UMC204HD IN 2"
                media.class = "Audio/Source"
                audio.position = [ MONO ]
            }
        }
    }
    {   name = libpipewire-module-loopback
        args = {
            node.description = "UMC204HD OUT 1"
            capture.props = {
                node.name = "UMC204HD OUT 1"
                media.class = "Audio/Sink"
                audio.position = [ FL FR ]
            }
            playback.props = {
                node.name = "UMC204HD OUT 1"
                audio.position = [ FL FR ]
                target.object = "alsa_output.usb-BEHRINGER_UMC204HD_192k-00.Direct__Direct__sink"
                stream.dont-remix = true
                node.passive = true
            }
        }
    }
    {   name = libpipewire-module-loopback
        args = {
            node.description = "UMC204HD OUT 2"
            capture.props = {
                node.name = "UMC204HD OUT 2"
                media.class = "Audio/Sink"
                audio.position = [ FL FR ]
            }
            playback.props = {
                node.name = "UMC204HD OUT 2"
                audio.position = [ RL RR ]
                target.object = "alsa_output.usb-BEHRINGER_UMC204HD_192k-00.Direct__Direct__sink"
                stream.dont-remix = true
                node.passive = true
            }
        }
    }

]
```
