#! /usr/bin/perl

use strict;
use warnings;

my $dict = $ENV{'HOME'} . '/my_words';

unless (-f $dict) {
    $dict = $ENV{'HOME'} . '/words.txt';
}

open(my $dfh, $dict) || die "Unable to open $dict: $!";
my @dict = <$dfh>;
chomp(@dict);
close($dfh);

# my @idx = (
#            rand(length(@dict)),
#            rand(length(@dict))
#           );

# print $dict[$idx[0]] . '-' . $dict[$idx[1]] . "\n";

my @word;

while (scalar(@word) < 2) {
  my $idx = rand(scalar(@dict));
  my $word = $dict[$idx];
  my @match = grep { $_ eq $word } @word;
  next if scalar(@match) > 0;
  push @word, $word;
}

print join('-', @word);
