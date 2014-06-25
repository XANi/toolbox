#!/usr/bin/env perl

use strict;
use warnings;
use Carp qw(croak cluck carp confess);
use Getopt::Long qw(:config auto_help);
use Pod::Usage;
use Data::Dumper;
use File::Slurp qw(read_file);
$ENV{'PATH'}= '/sbin:/bin:/usr/sbin:/usr/bin';
my $host = `/bin/hostname --fqdn`;
chomp($host);
my $cfg = { # default config values go here
    'device-glob' => 'sd*',
    'by-model'    => 1,
#    daemon  => 0,
#    pidfile => 0,
};
my $help;
$| = 1;
GetOptions(
#    'daemon'        => \$cfg->{'daemon'},
#    'pidfile=s'       => \$cfg->{'pidfile'},
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


my @devices = glob('/sys/block/' . $cfg->{'device-glob'});
my $dev_status;
foreach my $sysdev (@devices) {
    if (! -r "$sysdev/queue/rotational") {
        print STDERR "cant find $sysdev/queue/rotational";
        next;
    }

    my $is_hdd = read_file("$sysdev/queue/rotational");
    if ($is_hdd != 0) {
        next; # not a SSD
    }
    my ($dev) = $sysdev =~ m{/sys/block/(.+)$};
    my $pid = open(my $smart, '-|', '/usr/bin/sudo', '/usr/sbin/smartctl','-a',  "/dev/$dev");
    while(<$smart>) {
        chomp;
        my @line = split;
        if(!defined($line[1])) {next}
        if($line[0] =~ /Device/ && $line[1] =~ /Model/) {
            $dev_status->{$dev}{'model'} = $line[2];
            $dev_status->{$dev}{'model'} =~ s{[\-/\s]}{_}g;
        }
        if($line[0] =~ /Serial/i && $line[1] =~ /Number/i) {
            $dev_status->{$dev}{'serial'} = $line[2];
            $dev_status->{$dev}{'serial'} =~ s{[\-/\s]}{_}g;
        }
        if($line[1] =~ /Life_Curve_Status/i) {
            $dev_status->{$dev}{'life_curve_status'} = $line[3];
        }
        if($line[1] =~ /(SSD_Life_Left|Media_Wearout_Indicator)/i) {
            $dev_status->{$dev}{'ssd_life_left'} = $line[3];
        }
        if($line[1] =~ /Lifetime_Writes_GiB/i) {
            $dev_status->{$dev}{'write_gb'} = $line[9];
        }
        if($line[1] =~ /Lifetime_Reads_GiB/i) {
            $dev_status->{$dev}{'read_gb'} = $line[9];
        }
        if($line[1] =~ /Reallocated_Event_Count/i) {
            $dev_status->{$dev}{'reallocated'} = $line[9];
        }
        if($line[1] =~ /Program_Fail_Count/i) {
            $dev_status->{$dev}{'program_fail'} = $line[9];
        }
        if($line[1] =~ /Erase_Fail_Count/i) {
            $dev_status->{$dev}{'erase_fail'} = $line[9];
        }
        if($line[1] =~ /Retired_Block_count/i) {
            $dev_status->{$dev}{'retired_blocks'} = $line[9];
        }
        if($line[1] =~ /Reported_Uncor/i) {
            $dev_status->{$dev}{'reported_uncorrected'} = $line[9];
        }

        if($line[1] =~ /Power_Cycle_Count/i) {
            $dev_status->{$dev}{'power_cycle'} = $line[9];
        }

        if($line[1] =~ /Unexpect_Power/i) {
            $dev_status->{$dev}{'power_loss'} = $line[9];
        }

    }
    close($smart);
    waitpid($pid, 0);
}
my $t = int(time);
while(my ($dev, $data) = each(%$dev_status)) {
    my $prefix = "PUTVAL $host/ssd-";
    if ($cfg->{'by-model'}) {
        $prefix .= $data->{'model'} . '_'  . $data->{'serial'} . '/';
    } else {
        $prefix .= $dev . '/';
    }
    for my $var (grep {!/(serial|model)/} keys %$data)   {
        print $prefix . "gauge-$var" . ' interval=60 ' . "$t:" . $data->{$var} . "\n";
    }
}
