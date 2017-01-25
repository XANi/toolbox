## Add cert to keystore

`keytool -import -trustcacerts -file /etc/pki/some-ca.crt  -keystore /usr/java/jdk/jre/lib/security/cacerts`

default password for Oracle jdk `changeme`


## Display final java vars

`java -XX:+PrintFlagsFinal -version` note that names are used instead of commandline parameters, like  MaxHeapSize

`java -XX:+PrintCommandLineFlags` - to see what `java` runs with as default
