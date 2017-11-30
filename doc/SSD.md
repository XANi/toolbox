#### Secure erase

    hdparm --user-master u --security-set-pass Eins /dev/sdh
    hdparm --user-master u --security-erase Eins /dev/sdh
    hdparm -I /dev/sdh # security should be disabled after erase
    # in case it didnt
    hdparm --security-disable Eins /dev/sdh
