#!/usr/bin/perl

$gif_image = join ("/", $ENV{'DOCUMENT_ROOT'}, "2.jpg");

if (open (IMAGE, "<" . $gif_image)) {
	$no_bytes = (stat ($gif_image))[7];
	$piece_size = $no_bytes / 10;

	print "Content-type: image/jpeg", "\n";
	print "Content-length: $no_bytes", "\n\n";

	for ($loop=0; $loop <= $no_bytes; $loop += $piece_size) {
		read (IMAGE, $data, $piece_size);

		print $data;
	}
	close (IMAGE);

} else {
	print "Content-type: text/plain", "\n\n";
	print " No puedo abrir el archivo $gif_image", "\n";
}
exit (0);
