## Create mirrors

`aptly mirror create -architectures=amd64 jessie-main http://ftp.pl.debian.org/debian/ jessie main contrib non-free`
`aptly mirror create -architectures=amd64 jessie-updates http://ftp.pl.debian.org/debian/ jessie-updates main contrib non-free`
`aptly mirror create -architectures=amd64 jessie-security http://security.debian.org/ jessie/updates main contrib non-free`


### publish in subdir

`aptly publish -distribution stretch -origin=Debian snapshot stretch-main-2016-05-01 current` publishes snapshot in subdir "current". Origin: Debian is important for some apps like mini-buildd that check that field


### Filter out package from mirror

`aptly mirror edit -filter='!Name (~ ^puppet.*)' stretch-main`
