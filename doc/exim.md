Mostly stolen from [Exim Cheatsheet](http://bradthemad.org/tech/notes/exim_cheatsheet.php)


* `exim -bp` - list messages in queue
* `exim -bpc` - queue count
* `exim -bp | exiqsumm` - summary
* `exim -bt` - show how exim will route message
* `exim -q -v` - run queue
* `exim -M <message-id> ` - force message delivery
* `exiqgrep -zi | xargs exim -M` - force delivery of all frozen messages
