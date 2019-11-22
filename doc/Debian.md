# mini-buildd


## rebuild from source
  * `apt-get source pkg`
  * `cd pkg- ; debuild -i -us -uc -S`
  * or use `debuild -i -us -uc -sa -S` to also package .orig archive
  * `debsign -k AAAAAAAA pkg-1.2.3.changes`
  * `dput mini-buildd-some-where pkg-1.2.3.changes`

## Misc

* `dch` - changelog edit
* install `dh-systemd`, needed for some packages
* `apt-get --allow-releaseinfo-change update` - for when release changes from testing to stable and such
