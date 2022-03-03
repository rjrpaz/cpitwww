#!/usr/bin/perl

$delay = 1;
$date = "/bin/date";

print "Refresh: ", $delay, "\n";
print "Content-type: text/plain", "\n\n";

print `$date`;

exit (0);