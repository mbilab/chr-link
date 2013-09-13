#!/usr/bin/perl -w

use strict;
use Switch;

my $i;
my $j;
my $CHR_NUMBER = 16;

my $line;
my @array;

my $first;
my @info_list;
my @info_list_range;
push(@info_list_range, 0);
my $position_count = 0;

#Part 1: create the series of chr_gene_info.json file
print "\nPart 1: Create the series of informatic file.\n";
for($i = 0; $i < $CHR_NUMBER; $i++) {
  open READ_FILE, "< ./origin/chr/chr".($i + 1).".gene";
  open WRITE_FILE, "> ./gene_location/chr".($i + 1)."_gene_info.json";

  print WRITE_FILE "[\n";
  $first = 0;
  while( $line = <READ_FILE>) {
    chomp $line;
    $position_count++;
    @array = split("\t", $line);
    push(@info_list, $array[1]."\t".$array[0]."\t".$array[2]."\t".$array[3]);

    if(!$first) {
      print WRITE_FILE "{";
      $first++;
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
  push(@info_list_range, $position_count);

  close READ_FILE;
  close WRITE_FILE;
}
print "\n\t".$CHR_NUMBER." files, chr_gene_info.json is creadted.\n";

#Part 2: create the series of chr_link_info.json file
print "\nPart 2: Create the series of linking file.\n";
my @link_list;
my @link_list_range;
for($i = 0; $i <= $CHR_NUMBER; $i++) {
  $link_list_range[$i] = 0;
}

print "\n\tReading the file from \"ppidata\"...\n";
open READ_FILE, "< ./origin/ppidata";
while($line = <READ_FILE>) {
  chomp $line;
  @array = split("\t", $line);
  $array[1] = &number_to_letter($array[1]);
  $array[3] = &number_to_letter($array[3]);
  push(@link_list, $array[1]."\t".$array[0]."\t".$array[3]."\t".$array[2]);
  push(@link_list, $array[3]."\t".$array[2]."\t".$array[1]."\t".$array[0]);
}
close READ_FILE;

print "\n\tSorting the list...\n";
@link_list = sort(@link_list);

$i = 0;
while($link_list[$i]) {
  @array = split("\t", $link_list[$i]);
  $array[0] = &letter_to_number($array[0]);
  $array[2] = &letter_to_number($array[2]);
  $link_list[$i] = "$array[0]\t$array[1]\t$array[2]\t$array[3]";
  $i++;
}

print "\n\tGroup and count the link of each chromosome...\n";
$i = 0;
while($link_list[$i]) {
  @array = split("\t", $link_list[$i++]);
  $link_list_range[$array[0]]++;
}
for($i = 1; $i <= $CHR_NUMBER; $i++) {
  $link_list_range[$i] += $link_list_range[$i - 1];
}

my @info;
my @link;
my $k;

print "\n\tWriring files...\n";
for($k = 0; $k < $CHR_NUMBER; $k++) {
  open WRITE_FILE, "> ./chr".($k + 1)."_gene_link.json";
  print WRITE_FILE "[\n";
  for($i = $link_list_range[$k]; $i < $link_list_range[$k + 1]; $i++){
    @link = split("\t", $link_list[$i]);
    if($i == $link_list_range[$k]) {
      print WRITE_FILE "{";
    }
    else{
      print WRITE_FILE ",\n{";
    }
    for($j = $info_list_range[$link[0] - 1]; $j < $info_list_range[$link[0]]; $j++) { 
      @info = split("\t", $info_list[$j]);
      if($link[0] eq $info[0] && $link[1] eq $info[1]){
	print WRITE_FILE "\"s_chr_num\":".$link[0].", \"s_gene\":\"".$link[1]."\", \"s_start\":".$info[2].", \"s_end\":".$info[3];
      }
    }
    for($j = $info_list_range[$link[2] - 1]; $j < $info_list_range[$link[2]]; $j++) { 
      @info = split("\t", $info_list[$j]);
      if($link[2] eq $info[0] && $link[3] eq $info[1]){
	print WRITE_FILE ", \"t_chr_num\":".$link[2].", \"t_gene\":\"".$link[3]."\", \"t_start\":".$info[2].", \"t_end\":".$info[3]."}";
      }
    }
  }
  print WRITE_FILE "\n]";
  close WRITE_FILE;
}


sub number_to_letter {
  switch($_[0]) {
    case 1 { return "A"; }
    case 2 { return "B"; }
    case 3 { return "C"; }
    case 4 { return "D"; }
    case 5 { return "E"; }
    case 6 { return "F"; }
    case 7 { return "G"; }
    case 8 { return "H"; }
    case 9 { return "I"; }
    case 10 { return "J"; }
    case 11 { return "K"; }
    case 12 { return "L"; }
    case 13 { return "M"; }
    case 14 { return "N"; }
    case 15 { return "O"; }
    case 16 { return "P"; }
  }
}

sub letter_to_number {
  switch($_[0]) {
    case "A" { return "1"; }
    case "B" { return "2"; }
    case "C" { return "3"; }
    case "D" { return "4"; }
    case "E" { return "5"; }
    case "F" { return "6"; }
    case "G" { return "7"; }
    case "H" { return "8"; }
    case "I" { return "9"; }
    case "J" { return "10"; }
    case "K" { return "11"; }
    case "L" { return "12"; }
    case "M" { return "13"; }
    case "N" { return "14"; }
    case "O" { return "15"; }
    case "P" { return "16"; }
  }
}


