### pad number

`$padded_prio = sprintf('%04d',$prio) # 4 -> 0004`


### Install package from certain distro

    package {"sth":
        ensure => installed
        install_options => ' -t testing'
    }
