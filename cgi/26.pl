#!/usr/bin/perl

print "Content-type: text/plain", "\n\n";

$query_string = $ENV{'QUERY_STRING'};
($field_name, $command) = split (/=/, $query_string);

if ($command eq "fortune") {
	print `/usr/games/fortune`;
} elsif ($command eq "finger") {
	print `/usr/bin/finger`;
} else {
	print `/bin/date`;
}

exit (0);