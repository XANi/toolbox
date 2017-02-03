# replace key by name

`insert into trocla select encode(decode(replace(encode(decode(k,'base64'),'escape'),'bacula::fd','backup::fd'),'escape'),'base64') as k, v from trocla where encode(decode(k,'base64'),'escape') LIKE 'bacula::fd%';`
