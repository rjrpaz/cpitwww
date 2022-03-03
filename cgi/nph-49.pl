#!/usr/bin/perl

$server_protocol = $ENV{'SERVER_PROTOCOL'};
$server_software = $ENV{'SERVER_SOFTWARE'};

print "$server_protocol 200 OK", "\n";
print "Server: $server_software", "\n";
print "Content-type: text/plain", "\n\n";

print "Voy a contar desde 1 hasta 50", "\n";
	
$| = 1;
for ($loop=1; $loop <= 50; $loop++) { 
	print $loop, "\n";
	sleep (1);
}
print "Proceso finalizado", "\n";

exit (0);
