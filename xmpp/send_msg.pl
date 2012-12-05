#!/usr/bin/perl
#
# send single message via xmpp
# probably overkill but can be easily extended to micro-bot
use AnyEvent;
use AnyEvent::XMPP::Client;
use AnyEvent::XMPP::Ext::Disco;
use AnyEvent::XMPP::Ext::Version;

my $xmpp_user = '';
my $xmpp_pass = '';

binmode STDOUT, ":utf8";

my $j       = AnyEvent->condvar;
my $cl      = AnyEvent::XMPP::Client->new (debug => 1);
my $disco   = AnyEvent::XMPP::Ext::Disco->new;
my $version = AnyEvent::XMPP::Ext::Version->new;

$cl->add_extension ($disco);
$cl->add_extension ($version);

$cl->set_presence (undef, 'I\'m a talking bot.', 1);

$cl->add_account ($xmpp_user, $xmpp_pass);
warn "connecting to $xmpp_user...\n";

$cl->reg_cb (
   session_ready => sub {
      my ($cl, $acc) = @_;
      warn "connected!\n";
   },
   message => sub {
       my ($cl, $acc, $msg) = @_;
       my $repl = $msg->make_reply;
       $repl->add_body ('this is only sending bot');
       $repl->send;
   },
   contact_request_subscribe => sub {
      my ($cl, $acc, $roster, $contact) = @_;
      $contact->send_subscribed;
      warn "Subscribed to ".$contact->jid."\n";
   },
   error => sub {
      my ($cl, $acc, $error) = @_;
      warn "Error encountered: ".$error->string."\n";
      $j->broadcast;
   },
   disconnect => sub {
      warn "Got disconnected: [@_]\n";
      $j->broadcast;
   },
   connected => sub {
       $cl->send_message($ARGV[1], $ARGV[0]);
              $cl->send_message($ARGV[1], $ARGV[0]);
              $cl->send_message($ARGV[1], $ARGV[0]);
   },
);

$cl->start;




$j->wait;
