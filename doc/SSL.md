
# Self signed cert for testing

    openssl genrsa 2048 > host.key
    openssl req -new -x509 -nodes -sha1 -days 3650 -key host.key -addext "keyUsage=critical,keyCertSign,cRLSign" >host.crt

without keyusage it will not work for testing CRLs
