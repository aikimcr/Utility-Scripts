#! /usr/bin/perl

use strict;
use warnings;

my $input = '/etc/dictionaries-common/words';

unless (-f $input) {
    $input = $ENV{HOME} . '/words';
}

my $output = $ENV{HOME} . '/my_words';

open(my $ifh, $input) || die "Unable to open $input: $!";
open(my $ofh, "| /usr/bin/sort -u") || die "Unable to open sort: $!";

my %seen;

my @banned = qw(fuck shit bastard damn cunt bitch pussy cock penis labia faggot);

sub check_banned {
   my ($word) = @_;

   foreach my $banned (@banned) {
     return 1 if $word =~ /$banned/;
   }

   return 0;
}

while(my $line = <$ifh>) {
   chomp $line;
   $line = lc $line;
   next if $line =~ /[^a-z0-9]/;
   next if length($line) < 4;
   next if check_banned($line);
   next if exists $seen{$line};

   if ($line =~ /s$/) {
     my $seek = $line;
     $seek =~ s/s$//;
     next if exists $seen{$seek};

     if ($line =~ /es$/) {
       $seek = $line;
       $seek =~ s/es$//;
     }
     next if exists $seen{$seek};
   }

   $seen{$line} = 1;
   print $ofh $line . "\n";
}
