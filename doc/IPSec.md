## Openswan cheatsheet

* `ipsec auto --status` - verbose status
* `ipsec auto --down $i ;ipsec auto --delete $i` - delete $i connection
* `ipsec auto --add "$i" ; ipsec auto --replace "$i" ; ipsec auto --verbose --up "$i"` - add/replace a connection, spam crap about it on output
