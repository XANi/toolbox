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

timethis(-20, sub {
             my $batch = RocksDB::WriteBatch->new;
             my $batchid = rand;
             for my $z (1..1000) {
                 ++$count;
                 $batch->put($batchid . $z => $a);
             }
             $db->write($batch);
         }, "Write");

print "Count: $count\n";
