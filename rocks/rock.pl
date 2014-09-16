#!/usr/bin/perl
use RocksDB;
use Benchmark;
my $a;
for $b(1..10000) {
    $a .= rand;
}
my $db;
print "Data:" . length($a) . "\n";
system('du -h data');
timethis(1, sub {
             $db = RocksDB->new('data', { create_if_missing => 1 });
         }, "Open");

my $count;
timethis(1, sub {
             $db->put( asd => rand());
         },
         "First write");

timethis(-90, sub {
             my $batch = RocksDB::WriteBatch->new;
             my $batchid = rand;
             for my $z (1..10000) {
                 ++$count;
                 $batch->put($batchid . $z => $a);
             }
             print "end\n";
             $db->write($batch);
             print "write end\n";
         }, "Write");

print "Count: $count\n";
