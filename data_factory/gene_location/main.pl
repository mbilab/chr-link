#!/usr/bin/perl -w

use strict;
use Switch;

my $i;
my $CHR_NUMBER = 16;
my $line;
my @array;
my $tmp;

for($i = 0; $i < $CHR_NUMBER; $i++) {
  open READ_FILE, "< ../original_data/chr/chr".($i + 1).".gene";
  open WRITE_FILE, "> chr".($i + 1)."_gene_info.json";
  print WRITE_FILE "[\n";
  $tmp = 0;
  while($line = <READ_FILE>) {
    chomp $line;
    @array = split("\t", $line);
    if(!$tmp) {
      print WRITE_FILE "{";
      $tmp++;
    }
    else {
      print WRITE_FILE ",\n{";
    }
    print WRITE_FILE "\"code\":\"".$array[0]."\", ";
    print WRITE_FILE "\"chr_num\":".$array[1].", ";
    print WRITE_FILE "\"start\":".$array[2].", ";
    print WRITE_FILE "\"end\":".$array[3]."}";
  }

  print WRITE_FILE "\n]";

  close READ_FILE;
  close WRITE_FILE;
}

