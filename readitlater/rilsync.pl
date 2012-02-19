#!/usr/bin/perl
#use utf8;
use strict;
use warnings;
use Carp qw(croak cluck);
use LWP::UserAgent;
use HTTP::Request::Common;
use JSON;

use Data::Dumper;

my $apikey='aNqd2lf7Tf963C96c8A4758Oe7g3P2d6';
my $username='xani666';
my $password='xanilinuxpower1';

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
utf8::upgrade($content);
my $ril_state = from_json($content);
my $list = $ril_state->{'list'};

my @rsort = sort { $b <=> $a} keys %$list;

# initial org-mode config:
print '
#+STARTUP: entitiespretty
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
    print $d->{'title'} . ' [#' . $d->{'item_id'} . '] ';

    if ( defined $d->{'tags'} ) {
        my $taglist = $d->{'tags'} =~ s/\,/:/g;
        $taglist = ':' . $taglist . ':';
        print $taglist;
    }
    # and URL in next line
    print "\n  " . $d->{'url'} . "\n";
}
#print Dumper \@rsort;
#print Dumper from_json($content);
