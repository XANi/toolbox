### pad number

`$padded_prio = sprintf('%04d',$prio) # 4 -> 0004`


### Install package from certain distro

    package {"sth":
        ensure => installed
        install_options => ' -t testing'
    }


# Coding

https://docs.puppet.com/guides/custom_types.html

## Raise error from ruby

`raise ArgumentError, "error breaking the run`
`raise Puppet::Error, "different error type"`
