
* `cat file |gpg --with-fingerprint`  - show fingerprint without importing
* `gpg --keyring file.gpg --no-default-keyring --homedir /dev/null --export -a` - convert from binary to ascii keyring
