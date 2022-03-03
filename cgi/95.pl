#!/usr/bin/perl

print "Content type: text/plain", "\n\n";

$count_file = "/var/lib/httpd/htdocs/count.txt";

if (open (FILE, "<" . $count_file)) {
	$no_accesses = <FILE>;
	close (FILE);
	
	if (open (FILE, ">" . $count_file)) {
		$no_accesses++;

		print FILE $no_accesses;
		close (FILE);

		print $no_accesses;
	} else {
		print "[No puedo escribir en el archivo!. Contador no
incrementado]", "\n";
	}

} else {
	print "[ No puedo leer el archivo de datos del contador ]", "\n";
}

exit (0);
