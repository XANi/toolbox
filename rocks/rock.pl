#!/usr/bin/perl
use v5.10;
use feature "state";
use Data::Dumper;
use RocksDB;
use Benchmark;
use Getopt::Long;


GetOptions(
    'val-size=i'        => \$cfg->{'val-size'},
    'batch-size=s'      => \$cfg->{'batch-size'},
    'compact'           => \$cfg->{'compact'},
    'write'           => \$cfg->{'write'},
    'read'           => \$cfg->{'read'},
);
open(my $r, '<', '/dev/urandom');
sysread($r,$a,$cfg->{'val-size'});
while(length($a) < $cfg->{'val-size'}) {
    state $a = 0;
    if (!$a++) {
        say "weird non-full read, filling manually"
    }
    my $part;
    sysread($r,$part, ( $cfg->{'val_size'} - length($a)));
    if (!length($part)) {
        $part = chr(int(rand(256)));
    }
    $a .= $part;
}
my $db;
print "Data:" . length($a) . "\n";
system('du -h data');
timethis(1, sub {
             $db = RocksDB->new('data', {
                 create_if_missing => 1,
                 enable_statistics => 1,
                 num_levels => 4,
                 compaction_style => 'level',
                 delete_obsolete_files_period_micros => '600000000',
});
         }, "Open");
say "Rocksdb levels:" . $db->number_levels();



my $count;
timethis(1, sub {
             $db->put( asd => rand());
         },
         "First write");
if ($cfg->{'compact'}) {
    timethis(1, sub {
#                 $db->compact_range(undef,undef,{'target_level' => 2});
                 $db->compact_range
             },
             "compact");
    my $s = $db->get_statistics;
    print "stats: " . $s->to_string;
}
if ($cfg->{'write'}) {
    timethis(-10, sub {
                 my $batch = RocksDB::WriteBatch->new;
                 my $batchid = int(rand(100));
                 for my $z (1..10000) {
                     ++$count;
                     $batch->put($batchid . $z => $a);
                 }
                 print "end\n";
                 $db->write($batch);
                 print "write end\n";
             }, "Write");
    print "Count: $count\n";
}


if ($cfg->{'slow-write'}) {
    timethis(-10, sub {
                 my $batch = RocksDB::WriteBatch->new;
                 my $batchid = int(rand(100));
                 for my $z (1..10000) {
                     ++$count;
                     $batch->put($batchid . $z => $a);
                 }
                 print "end\n";
                 $db->write($batch);
                 sleep 10;
             }, "Write");
    print "Count: $count\n";
}

if ($cfg->{'read'}) {
    say "read";
    timethis(-10, sub {
                 my $batch = RocksDB::WriteBatch->new;
                 my $batchid = rand;
                 for my $z (1..1000) {
                     ++$count;
                     $db->get($batchid . $z);
                 }
                 $db->put( asd => rand());
                 sleep 10;
             }, "read");
    print "Count: $count\n";
}
