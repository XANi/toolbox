



    minio-client admin policy create local backup_writer backup_policy.json
    minio-client  admin user add local testuser adddddddd
    minio-client  admin policy attach local backup_writer --user testuser
    minio-client mb local/mybucket
    minio-client cp /tmp/testfile local/mybucket/testuser/test
