#! /usr/bin/perl

use strict;
use warnings;

use Getopt::Long;

sub logRevision {
    my ($logline) = @_;
    my @logline = split(/\s+/, $logline);
    return $logline[0];
}

my $current = shift @ARGV;
my $filename = shift @ARGV;

$current = 0 if ($current < 0);

my $next = $current + 1;
my $logc = sprintf("/usr/bin/git log --follow --pretty=oneline %s", $filename);

print "$logc\n";
my @log = `$logc`;
chomp(@log);

foreach my $log (@log) {
    print "$log\n";
}

if ($next >= scalar(@log)) {
    $next = scalar(@log);
    $current = $next -1;
    $current = 0 if $current < 0;
}

my $diffc = sprintf("/usr/bin/git diff %s %s %s", logRevision($log[$next]), logRevision($log[$current]), $filename);
print "$diffc\n";
system($diffc);

exit(0);

