#!/user/bin/perl -w

use strict;
my $line;
my $data;
my $r = 10;
my $s;
my $t;


while($r <= 100) {
  for($s = 1; $s <= 16; $s++) {
    for($t = 1; $t <= 16; $t++) {
      open FILE, "< ./".$r."/chr".$s."-".$t."_cor.json";
      while($line = <FILE>){
	chomp $line;
	if($s == 1 && $t == 1) {
	  $line =~ s/\]\]/\]/;
	  $data = $data.$line;
	}
	else {
	  if($s == 16 && $t == 16) {
	    $line =~ s/\[?//;
	    $data = $data.",".$line;
	  }
	  else {
	    $line =~ s/\[?//;
	    $line =~ s/\]\]/\]/;
	    $data = $data.",".$line;
	  }
	}
      }
      close FILE;
    }
  }

  open FILE2, "> ./r".$r."_cor.json";
  print FILE2 $data;
  $r = $r + 10;
  $data = "";
}
