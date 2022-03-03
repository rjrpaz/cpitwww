#!/usr/bin/perl

$fortune = "/usr/games/fortune";
$refresh_time = 5;

print "Refresh: ", $refresh_time, "\n";
print "Content-type: text/plain", "\n\n";

print "Aqui va otra fortune", "\n";
print `$fortune`;

exit (0);