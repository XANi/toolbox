#!/usr/bin/env perl
# puppet managed file, for more info 'puppet-find-resources $filename'


use strict;
use warnings;
use Carp qw(croak cluck carp confess);
use Getopt::Long qw(:config auto_help);
use Pod::Usage;
use Data::Dumper;
use File::Slurp qw(read_file);
use File::Basename;
use JSON;
$ENV{'PATH'}= '/sbin:/bin:/usr/sbin:/usr/bin';
# nvme needs that locale locale to display numbers without ',' in them
$ENV{'LC_ALL'} = 'C';
my $host = `/bin/hostname --fqdn`;
chomp($host);
my $cfg = { # default config values go here
    'device-re' => '(sd|nvme)',
    'by-model'    => 1,
    'interval'    => 300,
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

&print_ssd_status;
while(sleep $cfg->{'interval'}) {
    &print_ssd_status;
}

sub print_ssd_status {

    my @devices = glob('/sys/block/*');
    my $dev_status;
    foreach my $sysdev (@devices) {
        my ($dev,$path) = fileparse($sysdev);
        if ($dev !~ /$cfg->{'device-re'}/) {
            next;
        }
        my $is_hdd;
        if (-r "$sysdev/queue/rotational") {
            $is_hdd = read_file("$sysdev/queue/rotational");
        } elsif (-r "$sysdev/device/model") {
            # ugly hack for old kernel on c5
            my $f = read_file("$sysdev/device/model");
            if ($f =~ /(OCZ|Kingston|ADATA|Samsung SSD)/) {
                $is_hdd=0;
            } else { $is_hdd=1 }
        } else {
            print STDERR "cant find any way to detect if it is ssd for $sysdev\n";
            next;
        }
        if ($is_hdd != 0) {
            next; # not a SSD
        }
#        my ($dev) = $sysdev =~ m{/sys/block/(.+)$};
        my $pid = open(my $smart, '-|', '/usr/bin/sudo', '/usr/sbin/smartctl','-a',  "/dev/$dev");
        while(<$smart>) {
            chomp;
            my @line = split;
            if(!defined($line[1])) {next}
            if($line[0] =~ /Device/ && $line[1] =~ /Model/) {
                $dev_status->{$dev}{'model'} = join("_", @line[2..$#line]);
                $dev_status->{$dev}{'model'} =~ s{[\-/\s]}{_}g;
            }
            if($line[0] =~ /Model/ && $line[1] =~ /Number/ && !$dev_status->{$dev}{'model'}) {
                $dev_status->{$dev}{'model'} = join("_", @line[2..$#line]);
                $dev_status->{$dev}{'model'} =~ s{[\-/\s]}{_}g;
            }
            if($line[0] =~ /Serial/i && $line[1] =~ /Number/i) {
                $dev_status->{$dev}{'serial'} = $line[2];
                $dev_status->{$dev}{'serial'} =~ s{[\-/\s]}{_}g;
            }
            if($line[1] =~ /Life_Curve_Status/i) {
                $dev_status->{$dev}{'life_curve_status'} = $line[3] + 0;
            }
            if($line[1] =~ /(SSD_Life_Left|Media_Wearout_Indicator|Wear_Leveling_Count)/i) {
                $dev_status->{$dev}{'ssd_life_left'} = $line[3] + 0;
            }
            if($line[1] =~ /(Wear_Leveling_Count)/i && $line[9] > 0) {
                $dev_status->{$dev}{'wear_leveling_count'} = $line[9]+0;
            }

            if($line[1] =~ /Lifetime_Writes_GiB/i) {
                $dev_status->{$dev}{'write_bytes'} = $line[9] * 1024 * 1024 * 1024;
            }
            if($line[1] =~ /Lifetime_Reads_GiB/i) {
                $dev_status->{$dev}{'read_bytes'} = $line[9] * 1024 * 1024 * 1024;
            }
            if($line[1] =~ /Reallocated_(Event_Count|Sector_Ct)/i) {
                $dev_status->{$dev}{'reallocated'} = $line[9];
            }
            if($line[1] =~ /Program_Fail_(Cnt|Count)/i) {
                $dev_status->{$dev}{'program_fail'} = $line[9];
            }
            if($line[1] =~ /Erase_Fail_(Cnt|Count)/i) {
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

            if($line[1] =~ /Total_LBAs_Written/i) {
                $dev_status->{$dev}{'lba_written'} = $line[9];
            }
        }
        if (!defined($dev_status->{$dev}{'write_bytes'})
            && defined($dev_status->{$dev}{'lba_written'})) {
            $dev_status->{$dev}{'write_bytes'} = $dev_status->{$dev}{'lba_written'} * 512;
        }
        close($smart);
        waitpid($pid, 0);
        # NVMe
        # "data units" are 512b * 1000 ( https://wisesciencewise.wordpress.com/2017/05/22/c-program-to-read-and-interpret-smart-log-of-an-nvme-drive/ )
        if ($dev =~ /nvme/) {
            my $pid = open(my $nvme, '-|', '/usr/bin/sudo', '/usr/sbin/nvme', 'smart-log',  "/dev/$dev", "--output=json");

            my $nvme_json = do { local $/;  <$nvme> };
            my $nvme_data;
            eval {
                $nvme_data = decode_json($nvme_json);
            };
            if (!defined($nvme_data)) {
                carp($@);
                next;
            }
            # the unit is "thousand 512 byte sectors"
            # fuck whichever twat invented it
            if ($nvme_data->{'data_units_written'}) {
                $dev_status->{$dev}{'write_bytes'} = $nvme_data->{'data_units_written'} * 512 * 1000;
            }
            if ($nvme_data->{'data_units_read'}) {
                $dev_status->{$dev}{'read_bytes'} = $nvme_data->{'data_units_read'} * 512 * 1000;
            }
            $dev_status->{$dev}{'media_errors'} ||= $nvme_data->{'media_errors'};
            $dev_status->{$dev}{'error_log_entries'} ||= $nvme_data->{'num_err_log_entries'};
            $dev_status->{$dev}{'power_on_hours'} ||= $nvme_data->{'power_on_hours'};
            $dev_status->{$dev}{'power_cycle'} ||= $nvme_data->{'power_cycles'};
            $dev_status->{$dev}{'power_loss'} ||= $nvme_data->{'unsafe_shutdowns'};
            if ($nvme_data->{'avail_spare'})  {
                $dev_status->{$dev}{'available_spare'} = $nvme_data->{'avail_spare'};
            }
            if ($nvme_data->{'percent_used'}) {
                $dev_status->{$dev}{'ssd_life_left'} = 100 - $nvme_data->{'percent_used'};
            }
            if($nvme_data->{'temperature'}) {
                $dev_status->{$dev}{"temperature_core"} = $nvme_data->{'temperature'} - 273; # temp given is integer so we round off kelvin too
            }
            if($nvme_data->{'temperature_sensor_1'}) {
                $dev_status->{$dev}{"temperature_sensor_1"} = $nvme_data->{'temperature_sensor_1'} - 273; # temp given is integer so we round off kelvin too
            }
            if($nvme_data->{'temperature_sensor_2'}) {
                $dev_status->{$dev}{"temperature_sensor_2"} = $nvme_data->{'temperature_sensor_2'} - 273; # temp given is integer so we round off kelvin too
            }
            close($nvme);
            waitpid($pid, 0);
        }

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
            my $unit = 'gauge';
            my $instance = $var;
            if ($var =~ /_bytes$/) { $unit = 'bytes' }
            elsif ($var =~ /_left/) { $unit = 'percent' }
            elsif ($var =~/^temperature_(.+)/) {
                $unit = 'temperature';
                $instance = $1;
            }
            print $prefix . "$unit-$instance" . " interval=$cfg->{'interval'} " . "$t:" . $data->{$var} . "\n";

        }
    }
};
