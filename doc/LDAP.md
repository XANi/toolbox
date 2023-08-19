# LDAP

## 389-ds

### ACL/ACI

 * allow user to modify its own arguments `(targetattr="userPassword || nsSshPublicKey")(version 3.0; acl "Enable self partial modify"; allow (write)(userdn="ldap:///self");)'`
 * allow reading any group that has jdoe member to anyone: `(targetattr = "*") (targetfilter = (|(memberUid=jdoe)(ou=groups))) (version 3.0;acl "test auth";allow (read,compare,search)(userdn = "ldap:///anyone");)`
