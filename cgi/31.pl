#!/usr/bin/perl

$plaintext_file = $ENV{'PATH_TRANSLATED'};

print "Content-type: text/plain", "\n\n";
print "cacho:  ", $plaintext_file, "\n";

if ($plaintext_file =~ /\.\./) {
	print "Momento. Utilizaste caracteres no permitidos", "\n";
	print "Creiste que ibamos a caer, je je je", "\n";
} else {
	if (open (FILE, "<" . $plaintext_file)) {
		while (<FILE>) {
			print;
		}
		close (FILE);
	} else {
		print "No puedo leer ese archivo", "\n";
	}
}
exit (0);