### pad number

`$padded_prio = sprintf('%04d',$prio) # 4 -> 0004`

### path to file in repo in template

    # <%=  __FILE__.gsub(/.*?modules\//,'puppet://modules/') %>

will result in "puppet-like" `# puppet://modules/network/templates/ifcfg.erb`, while

    # <%=  __FILE__.gsub(/.*?modules\//,@fqdn + ':') %>
   
will result in `# server.example.com:bird/templates/part.conf`

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
