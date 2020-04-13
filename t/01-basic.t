use v6.c;
use Test;
plan 2;

use-ok 'Net::Github::V4', 'can load Net::Github::V4';

use Net::Github::V4;
my $client = Net::Github::V4.new(:access-token<bla>);

isa-ok $client, Net::Github::V4;
