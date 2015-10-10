# template for new commandline scripts
use strict;
use warnings;
use Carp qw(croak cluck carp confess);
use Getopt::Long qw(:config auto_help);
use Pod::Usage;
use Data::Dumper;

my $cfg = { # default config values go here
#    daemon  => 0,
#    pidfile => 0,
};
my $help;

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
# daemon/pidfile support

# my $pid = $$;
# if ($cfg->{'daemon'}) {
#     $pid = fork or die($!);
# }

# if($pid && $cfg->{'pidfile'}) {
#     open(P, '>', $cfg->{'pidfile'}) or die($!);
#     print P $pid;
#     close(P);
# }

# if ($pid && $cfg->{'daemon'}) {
#     exit;
# }


# put code here




__END__

=head1 NAME

foobar - get foo from bar

=head1 SYNOPSIS

foobar --option1 val1

=head1 DESCRIPTION

Does foo to bar

=head1 OPTIONS

parameters can be shortened if unique, like  --add -> -a

=over 4

=item B<--option1> val2

sets option1 to val2. Default is val1

=item B<--help>

display full help

=back

=head1 EXAMPLES

=over 4

=item B<foobar>

Does foo to bar with defaults

=item B<foobar --bar bar2>

Does foo to specified bar

=back

=cut
