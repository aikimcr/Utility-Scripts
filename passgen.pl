#! /usr/bin/perl

use strict;
use warnings;

use Getopt::Long;

my @upper_alpha = ('A'..'Z');
my @lower_alpha = ('a'..'z');
my @digits = ('0'..'9');
my @special = ('-', '_', '.');

my %options = (
  use_special => 0,
  length => 8,
  use_extra => 0,
);

GetOptions (
  'special|s!' => \$options{use_special},
  'length|len|l=i' => \$options{length},
  'extra|e' => sub {
    my ($optname, $value) = @_;

    if (!$options{use_extra}) {
      push @special, ('!', '*', '&', '#', '@', '+');
      $options{use_extra} = 1;
      $options{use_special} = 1;
    }
  },
) or die ("Error in command line arguments: $!\n");

sub shuffle_chars {
  my @charset = @_;

  for (1..100) {
    my @shuffled;

    while (scalar(@charset)) {
      my $charnum = rand(scalar(@charset));
      my $char = splice(@charset, $charnum, 1);
      push @shuffled, $char;
    }

    @charset = @shuffled;
  }

  return @charset;
}

my @alpha_chars = shuffle_chars(@upper_alpha, @lower_alpha);
my @charset;

if ($options{use_special}) {
  @charset = shuffle_chars(
    @upper_alpha,
    @lower_alpha,
    @digits, @digits,
    @special, @special,
  );
} else {
  @charset = shuffle_chars(
    @upper_alpha,
    @lower_alpha,
    @digits, @digits,
  );
}

my $len = $options{length};
my $mid_len = int($len / 2);
my $max_freq = int($len / 4) || 1;
my $special_chars = 0;
my $digits = 0;

my @chars;

push @chars, $alpha_chars[rand(scalar(@alpha_chars))];

print $len . ', ' . $mid_len . ', ' . $max_freq . "\n";

while (scalar(@chars) < $len) {
  my $char;

  if ($options{use_special} && $special_chars < 1 && scalar(@chars) >= $mid_len) {
    $char = $special[rand(scalar(@special))];
  } elsif ($digits < 1 && scalar(@chars) >= $mid_len) {
    $char = $digits[rand(scalar(@digits))];
  } else {
    $char = $charset[rand(scalar(@charset))];
  }

  next if $char eq $chars[-1];

  my @freq = grep { $_ eq $char } @chars;
  next if scalar(@freq) > $max_freq;

  if (scalar(grep { $_ eq $char } @special)) {
  # if ($char ~~ \@special) {
    $special_chars++;
  }

  if (scalar(grep { $_ eq $char } @digits)) {
  # if ($char ~~ \@digits) {
    $digits++;
  }

  push @chars, $char;
}

print join('', @chars) . "\n";
