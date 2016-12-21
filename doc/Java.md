## Add cert to keystore

`keytool -import -trustcacerts -file /etc/pki/some-ca.crt  -keystore /usr/java/jdk/jre/lib/security/cacerts`

default password for Oracle jdk `changeme`
