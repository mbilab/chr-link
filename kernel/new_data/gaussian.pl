#!/user/bin/perl -w

use strict;
use JSON;
use Math::Trig;

my $line;
my @array;
my $CHR_NUMBER = 16;
my $resolution;
my $start_sigma = 1;
my $end_sigma = 100;
my $increment = 5;
my $sigma;
my $tmp;
my $s;
my $t;
my $i;
my $j;
my $k;
my $index;

my $time1;
my $time2; 
my $timedif;

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

my $tmp_x;
my $tmp_y;

for($resolution = 30; $resolution <= 100; $resolution = $resolution + 10) {

for($sigma = $start_sigma; $sigma <= $resolution; $sigma = $sigma + $increment) {
  if($sigma == 6) {
    $sigma = $sigma - 1;
  }
  print "----------------------------------------------------------------\n";
  print "resolution = $resolution, sigma = $sigma\n";
  print "Reading file ...\n";

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

  $time1 = time();
  print "Read over. Start to gaussian distribution calculating ...\n";

  #&print_matrix;

  for($source = 1; $source <= $CHR_NUMBER; $source++) {
    for($target = 1; $target <= $CHR_NUMBER; $target++) {

      print "resolution = $resolution, sigma = $sigma, source = $source, target = $target\n";
      open FILE, "< ./list/r".$resolution."_chr".$source."-".$target.".json";
      $line = <FILE>;
      if($line) {
	@list = split(",", $line);
	close FILE;

	$st_row = ($target - 1) * $resolution;
	$st_col = ($source - 1) * $resolution;

	while(@list) {
	  $tmp_y = pop @list;
	  $tmp_x = pop @list;
	  for($row = $st_row; $row < $st_row + $resolution; $row++) {
	    for($col = $st_col; $col < $st_col + $resolution; $col++) {
	      $index = &find_index($col, $row);
	      if($tmp_x != $col || $tmp_y != $row) {
		$array[$index] += &gaussian($tmp_x, $tmp_y, $col, $row, $sigma);
	      }
	    }
	  }
	}
      }
    }
  }

  $time2 = time();
  $timedif = $time2 - $time1;
  print "Completed the calculation. Spend $timedif seconds. Now writing to file ...\n";

  #&print_matrix;

  open FILE, "> ./matrix/r".$resolution."_s".$sigma.".json";

  print FILE "[";
  for($i = 0; $i < $resolution * $CHR_NUMBER; $i++) {
    print FILE "[";
    for($j = 0; $j < $resolution * $CHR_NUMBER; $j++) {
      $index = &find_index($j, $i);
      print FILE $array[$index];
      if($j != $resolution * $CHR_NUMBER - 1) {
	print FILE ",";
      }
    }
    print FILE "]";
    if($i != $resolution * $CHR_NUMBER - 1) {
      print FILE ",";
    }
  }
  print FILE "]";

  close FILE;
  print "\n./matrix/r".$resolution."_s".$sigma.".json has been created.\n";


}
}

sub find_index {
  my($col, $row) = @_;
  return ($row * $CHR_NUMBER * $resolution + $col);
}

sub gaussian {
  my($cx, $cy, $x, $y, $sigma) = @_;
  my $coefficient = 1 / ($sigma * sqrt(2 * pi));
  my $constant = 2 * $sigma * $sigma;
  my $distance = ($x - $cx) ** 2 + ($y - $cy) ** 2;
  my $result = int(10000 * $coefficient * exp(-$distance / $constant)) / 10000;
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


