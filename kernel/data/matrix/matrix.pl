#!/user/bin/perl -w

use strict;

my $line;
my @array;
my $CHR_NUMBER = 16;
my $resolution;
my $size;
my $col;
my $row;
my $element;
my $i;
my $j;

for($resolution = 10; $resolution <= 100; $resolution = $resolution + 10) {

  $size = $CHR_NUMBER * $resolution;
  open FILE, "< ./cor/r".$resolution."_cor.json";

  while($line = <FILE>) {
    chomp $line;
    $line =~ s/\[//g;
    $line =~ s/\]//g;
    @array = split(",", $line);

    open FILE2, "> ./r".$resolution.".json";
    print FILE2 "[";
    for($row = 0; $row < $size; $row++) {
      print FILE2 "\n[";
      for($col = 0; $col < $size; $col++) {
	$element = $resolution * (int($col / $resolution) * $CHR_NUMBER * $resolution + $row) + ($col % $resolution);
	print FILE2 $array[$element];
	if($col != ($size - 1)) {
	  print FILE2 ",";
	}
      }
      print FILE2 "]";
      if($row != ($size - 1)) {
	print FILE2 ",";
      }
    }
    print FILE2 "\n]";
  }

}
