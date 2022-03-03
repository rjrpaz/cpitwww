#!/usr/bin/perl

$gif_image = join ("/", $ENV{'DOCUMENT_ROOT'}, "2.jpg");

if (open (IMAGE, "<" . $gif_image)) {
	$no_bytes = (stat ($gif_image))[7];

	print "Content-type: image/jpeg", "\n";
	print "Content-length: $no_bytes", "\n\n";

	print <IMAGE>;
} else {
	print "Content-type: text/plain", "\n\n";
	print " No puedo abrir el archivo $gif_image", "\n";
}
exit (0);
