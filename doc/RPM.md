

== Snippets

=== Rebuild/repair RPM DB ==

    # rm -f /var/lib/rpm/__db*
    db_verify /var/lib/rpm/Packages
    rpm --rebuilddb
    yum clean all


## RPMBUILD

* `%define _unpackaged_files_terminate_build 0`
* `%define _missing_doc_files_terminate_build 0`
