#!/usr/bin/perl
#use utf8;
use common::sense;
use Carp qw(croak cluck);
use LWP::UserAgent;
use HTTP::Request::Common;
use JSON;

use Data::Dumper;
use POSIX;

my $apikey='';
my $username='';
my $password='';

my $ua = LWP::UserAgent->new();
$ua->timeout(20);
$ua->env_proxy;
#my $req = POST('http://127.0.0.1:12345/v2/get', [
my $req = POST('https://readitlaterlist.com/v2/get', [
    apikey => $apikey,
    username => $username,
    password => $password,
    format => 'json',
#    state => 'all', # read/unread/all
    myAppOnly => 0, # 1 for things only from that api key
    # since => 12345, # unix time
    # count => 100 # empty for all
    # page => # count * page for paging
    tags => 1, # default = 0
]);
my $content = $ua->request($req)->content();
#utf8::upgrade($content);
my $ril_state = from_json($content);
print STDERR Dumper $ril_state;
#utf8::upgrade($ril_state);
my $list = $ril_state->{'list'};

my @rsort = sort { $b <=> $a} keys %$list;

# initial org-mode config:
print '
#+STARTUP: entitiespretty
#+CATEGORY: RItLater
#+SEQ_TODO: UNREAD(u) READ(r)
';

foreach (@rsort) {
    my $id = $_;
    my $d = $list->{$id};
    print "* " ;
    # First, display state
    if ( $d->{'state'} == 1 ) {
        print 'READ ';
    }
    elsif ($d->{'state'} eq "0") {
        print 'UNREAD ';
    }
    else {
        print 'UNKN? ';
    }

    # Then title, ID
    if ( $d->{'title'} =~ /^\s*$/ ) {
        print '[[' . $d->{'url'}. '][' . $d->{'url'} . ']]';
    } else {
        my $parsed_title = $d->{'title'};
        $parsed_title =~ s/\[/\{/g;
        $parsed_title =~ s/\]/\}/g;
        print '[[' . $d->{'url'}. '][' . $parsed_title . ']]';
    }
    print ' [#' . $d->{'item_id'} . '] ';
    if ( defined $d->{'tags'} ) {
        my $taglist = $d->{'tags'} =~ s/\,/:/g;
        $taglist = ':' . $taglist . ':';
        print $taglist;
    }
    # and timestamp in next line
    print "\n  " . strftime( 'Added: <%F %a %R>',  localtime($d->{'time_added'}) );
    if ( $d->{'time_added'} =! $d->{'time_updated'} ) {
        print strftime( '  Modified: <%F %a %R>',  localtime($d->{'time_updated'}) );
    }
    print "\n";
}
#print Dumper \@rsort;
#print Dumper from_json($content);
