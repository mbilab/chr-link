#!/user/bin/perl -w

use strict;

my $CHR_NUMBER = 3;
my $resolution = $ARGV[0];
my $i;
my $j;
my $num;
my $time = $CHR_NUMBER * $resolution;

open FILE, "> r".$resolution.".json";

print FILE "[";

for($i = 0; $i < $time; $i++) {
  print FILE "[";
  for($j = 0; $j < $time; $j++) {
    $num = (rand() * 1000) % (rand() * 2 + 1);
    print FILE $num;
    if($j != ($time - 1)) {
      print FILE ",";
    }
  }
  print FILE "]";
  if($i !=  ($time - 1)) {
    print FILE ",";
  }
}

print FILE "]";

close FILE;
