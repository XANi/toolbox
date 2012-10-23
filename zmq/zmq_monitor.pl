#!/usr/bin/perl

use strict;
use warnings;
use 5.10.0;
use JSON;
use ZeroMQ qw/:all/;

use Data::Dumper;
$Data::Dumper::Terse=1;

my $context = ZeroMQ::Context->new();
$|=1;
my $filter='';
if( defined($ARGV[0]) ) {
    $filter = $ARGV[0];
}
# Socket to talk to server
say 'Connecting to hello world server';
my $requester = $context->socket(ZMQ_SUB);
$requester->connect('epgm://eth0;239.3.2.1:5555');
$requester->setsockopt(ZMQ_SUBSCRIBE, $filter);
while(1)  {
    my ($tag, $json) = split(/\|/, $requester->recv->data,2);
    my $data;
    eval {
    	$data = from_json($json);
    };
    if( defined($data) ) {
    	print "RECV: $tag JSON DUMP:\n";
    	print Dumper $data;
    } elsif ( defined($json) ) {
    	print "RECV: $tag RAW DUMP:\n";
    	print $json;
	print "\n";
    } else {
	print "RECV: RAW:\n";
	print $requester->recv->data;
	print "\n";
   }

}
