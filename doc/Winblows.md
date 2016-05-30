* `%systemroot%\system32\scrnsave.scr /s` - blank screen
* `shutdown /t 7200 /s` - shutdown in 2h

* `netsh int tcp show global` (look for Receive Window Auto Tuning Level, it should say normal, not disabled)
enable:
* `netsh int tcp set global autoturninglevel=enabled`
