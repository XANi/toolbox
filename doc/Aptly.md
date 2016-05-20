## Create mirrors

`aptly mirror create -architectures=amd64 jessie-main http://ftp.pl.debian.org/debian/ jessie main contrib non-free`
`aptly mirror create -architectures=amd64 jessie-updates http://ftp.pl.debian.org/debian/ jessie-updates main contrib non-free`
`aptly mirror create -architectures=amd64 jessie-security http://security.debian.org/ jessie/updates main contrib non-free`
