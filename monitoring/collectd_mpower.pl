#!/usr/bin/env perl

use strict;
use warnings;
use Carp qw(croak cluck carp confess);
use Getopt::Long qw(:config auto_help);
use Pod::Usage;
use Data::Dumper;
$ENV{'PATH'}= '/sbin:/bin:/usr/sbin:/usr/bin';
my $host = `/bin/hostname --fqdn`;
chomp($host);
my $cfg = { # default config values go here
    host       => 'mpower',
    user       => 'power',
    'interval' => 30,
};
my $help;
$| = 1;
GetOptions(
    'interval=i' => \$cfg->{'interval'},
    'host'       => \$cfg->{'host'},
    'user'       => \$cfg->{'user'},
    'help'          => \$help,
) or pod2usage(
    -verbose => 2,  #2 is "full man page" 1 is usage + options ,0/undef is only usage
    -exitval => 1,   #exit with error code if there is something wrong with arguments so anything depending on exit code fails too
);

# some options are required, display short help if user misses them
my $required_opts = [ ];
my $missing_opts;
foreach (@$required_opts) {
    if (!defined( $cfg->{$_} ) ) {
        push @$missing_opts, $_
    }
}

if ($help || defined( $missing_opts ) ) {
    my $msg;
    my $verbose = 2;
    if (!$help && defined( $missing_opts ) ) {
        $msg = 'Opts ' . join(', ',@$missing_opts) . " are required!\n";
        $verbose = 1; # only short help on bad arguments
    }
    pod2usage(
        -message => $msg,
        -verbose => $verbose, #exit code doesnt work with verbose > 2, it changes to 1
    );
}


$| = 1;

open(my $mpower_fd, '-|',
     "ssh",
     $cfg->{'user'} . '@' . $cfg->{'host'},
     '--',
     "while sleep $cfg->{'interval'}" . ' ; '
         . 'do for a in 1 2 3 4 5 6 ; '
         . 'do echo -n "$a:" ; '
         . 'cat /proc/power/active_pwr$a /proc/power/v_rms$a /proc/power/i_rms$a /proc/power/pf$a | tr "\n" ":" ; echo ;'
         . ' done ; done');
while(<$mpower_fd>) {
    chomp;
    my($socket, $power, $voltage, $current, $power_factor) =  split (/:/);
    my $t = int(time());
    if (!defined($voltage)) { next ; } #ignore trash
    print "PUTVAL $host/mpower-socket$socket/power interval=$cfg->{'interval'} $t:$power\n";
    print "PUTVAL $host/mpower-socket$socket/current interval=$cfg->{'interval'} $t:$power\n";
    print "PUTVAL $host/mpower-socket$socket/voltage interval=$cfg->{'interval'} $t:$power\n";
    print "PUTVAL $host/mpower-socket$socket/gauge-power_factor interval=$cfg->{'interval'} $t:$power\n";
}


__END__

=head1 NAME

collectd_mpower.pl - collect power usage from ubiquitiy mpower


=head1 SYNOPSIS

collectd_mpower.pl --host hostname --user username

=head1 USAGE

This program relies on SSH setup for device

After setting password in panel, do ssh-copy-id user@host to setup your key
