#!/usr/bin/perl

print "Content-type: text/plain", "\n\n";

print "Voy a contar desde 1 hasta 50", "\n";
	
$| = 1;
for ($loop=1; $loop <= 50; $loop++) { 
	print $loop, "\n";
	sleep (1);
}
print "Proceso finalizado", "\n";

exit (0);
