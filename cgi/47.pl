#!/usr/bin/perl

$remote_host = $ENV{'REMOTE_HOST'};

print "Content-type: text/plain", "\n";

if ($remote_host eq "localhost") {
	print "Status: 200 OK", "\n\n";
	print "Vos sos del localhost, je je je", "\n";
} else {
	print "Status: 400 Bad Request", "\n\n";
	print "Tenes que acceder a este servicio desde localhost", "\n";
}

exit (0);
