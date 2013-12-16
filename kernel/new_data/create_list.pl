#!/user/bin/perl -w

use strict;
use JSON;
use Math::Trig;

my $line;
my @array;
my $CHR_NUMBER = 16;
my $resolution;
my $sigma;
my $tmp;
my $s;
my $t;
my $i;
my $j;
my $k;
my $index;

my $row;
my $col;
my @list;

my $element;
my @cor;
my $st_row;
my $st_col;
my $source;
my $target;

my $tmpp;

for($resolution = 10; $resolution <= 100; $resolution = $resolution + 10) {
  open FILE, "< ./source_data/r".$resolution.".json";

  $tmp = "";
  while($line = <FILE>) {
    chomp $line;
    $tmp = $tmp.$line;
  }
  close FILE;
  $tmp =~ s/\[//g;
  $tmp =~ s/\]//g;
  @array = split(",", $tmp);


  #&print_matrix;

  for($source = 1; $source <= $CHR_NUMBER; $source++) {
    for($target = 1; $target <= $CHR_NUMBER; $target++) {

      $st_row = ($target - 1) * $resolution;
      $st_col = ($source - 1) * $resolution;
      for($row = $st_row; $row < $resolution + $st_row; $row++) {
	for($col = $st_col; $col < $resolution + $st_col; $col++) {
	  $index = &find_index($col, $row);
	  if($array[$index] != 0) {
	    push(@list, $col.",".$row);
	  }
	}
      }

      open FILE, "> ./list/r".$resolution."_chr".$source."-".$target.".json";

=pod
      print FILE "[";
      for($i = 0; $i <= $#list; $i++) {
	print FILE "\n[$list[$i]]";
	if($i != $#list) {
	  print FILE ",";
	}
      }
      print FILE "\n]";
=cut
      for($i = 0; $i <= $#list; $i++) {
	print FILE $list[$i];
	if($i != $#list) {
	  print FILE ",";
	}
      }
      close FILE;


      while(@list) {
	pop @list;
      }

      print "\n\t./list/r".$resolution."_chr".$source."-".$target.".json has created.";

    }
  }
}

print "\n";

sub find_index {
  my($col, $row) = @_;
  return ($row * $CHR_NUMBER * $resolution + $col);
}

sub gaussian {
  my($cx, $cy, $x, $y, $sigma) = @_;
  my $coefficient = 1 / ($sigma * sqrt(2 * pi));
  my $constant = 2 * $sigma * $sigma;
  my $distance = ($x - $cx) ** 2 + ($y - $cy) ** 2;
  my $result = $coefficient * exp(-$distance / $constant);
  return $result;
}

sub print_matrix {
  print "\n";
  for($i = 0; $i < $resolution * $CHR_NUMBER; $i++) {
    print "\t".$i;
  }
  for($i = 0; $i < $resolution * $CHR_NUMBER; $i++) {
    print "\n$i";
    for($j = 0; $j < $resolution * $CHR_NUMBER; $j++) {
      $index = &find_index($j, $i);
      print "\t".$array[$index];
    }
  }
  print "\n";
}


