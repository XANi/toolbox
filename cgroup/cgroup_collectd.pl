#!/usr/bin/perl
#
# Collectd plugin for cgroup stats

# TODO:
#  Getopt::Long
#  autofind cgroup fs
#
# USAGE:
#<Plugin exec>
#	Exec some-user-with-nopasswd-sudo "sudo" "/usr/local/bin/cgroup_collectd.pl"
#</Plugin>
use strict;
use warnings;
use Sys::Hostname;
my $host = hostname;            # TODO fqdn ?


my $cgroup_dir='/sys/fs/cgroup';
my $cgroup_update_every=60;

# first, find cgroups
sub get_cgroups {
    open(F, '-|', "find $cgroup_dir -type d");
    my @cgroup_list;
    while (<F>) {
        chomp;
        push @cgroup_list, $_;
    }
    close(F);
    return \@cgroup_list;
}
my $cgroup_update=0;
my $last_run=scalar time();
my $cgroups;
my $interval;

while (sleep 10) {
    $interval = time - $last_run;
    $last_run = time;
    if ( (scalar time() - $cgroup_update) > $cgroup_update_every) {
        $cgroups = &get_cgroups();
    }
    if ( defined($cgroups) ) {
        foreach (@$cgroups) {
            my $dir = $_;
            my ($name) = $_ =~ /^.*\/(.+?)$/;
            if ($name eq 'cgroup') {
                $name = 'total';
            }
            &get_stats($dir, $name);
        }
    }
}

sub get_stats {
    my $dir = shift;
    my $cgroup = shift;

    if ( open(my $f, '<', "$dir/cpuacct.usage") ) {
        my $val = <$f>;
        chomp($val);
        &printval($cgroup, 'cpu_ticks', 'derive', $val);
    }
    if ( open(my $f, '<', "$dir/cpuacct.stat") ) {
        while (<$f>) {
            chomp;
            my ($name, $val) = split;
            &printval($cgroup, "cpu_$name", 'derive', $val);
        }
    }
    if ( open(my $f, '<', "$dir/memory.usage_in_bytes") ) {
        my $val = <$f>;
        chomp($val);
        &printval($cgroup, 'mem_used', 'bytes', $val);
    }
}

sub printval { # TODO parameters in hash, not list
    my $cgroup = shift;
    my $name = shift;
    my $type = shift;
    my $val  = shift;
    my $t = scalar time;
    print "PUTVAL $host/cgroup-$cgroup/$type-$name interval=$interval $t:$val\n";
}
