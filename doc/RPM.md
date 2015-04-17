

== Snippets

=== Rebuild/repair RPM DB ==

    # rm -f /var/lib/rpm/__db*
    db_verify /var/lib/rpm/Packages
    rpm --rebuilddb
    yum clean all
