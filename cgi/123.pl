#!/usr/bin/perl

use GD;

$| = 1;
$webmaster = "shishir\@bu\.edu";

$exclusive_lock = 2;
$unlock_lock = 8;
$counter_file = "/var/lib/httpd/htdocs/count.txt";
$no_visitors = 1;

if (! (-e $counter_file)) {
	if (open (COUNTER, ">" . $counter_file)) {
		flock (COUNTER, $exclusive_lock);
		print COUNTER $no_visitors;
		flock (COUNTER, $unlock_lock);
		close (COUNTER);
		} else {
		&return_error (500, "Counter Error", "No puedo crear archivo
de datos para guardar informacion del contador.");
}

} else {
if (! ((-r $counter_file) && (-w $counter_file)) ) {
	&return_error (500, "Counter error", "No se puede escribir o leer el
archivo");

} else {
	open (COUNTER, "<" . $counter_file);
	flock (COUNTER, $exclusive_lock);
	$no_visitors = <COUNTER>;
	flock (COUNTER, $unlock_lock);
	close (COUNTER);
	$no_visitors++;
	open (COUNTER, ">" . $counter_file);
	flock (COUNTER, $exclusive_lock);
	print COUNTER $no_visitors;
	flock (COUNTER, $unlock_lock);
	close (COUNTER);
}
}

&graphic_counter();
exit (0);

sub graphic_counter
{
	local ($count_length, $font_length, $font_height, $distance,
	$border, $image_length, $image_height, $image, $black, $blue, $red,
	$loop, $number, $temp_x);

$count_length = length ($no_visitors);
$font_length = 8;
$font_height = 16;

$distance = 3;
$border = 4;

$image_length = ($count_length * $font_length) + (($count_length -1) * $distance) + $border;
$image_height = $font_height + $border;

$image = new GD::Image ($image_length, $image_height);

$black = $image->colorAllocate (0, 0, 0);
$blue = $image->colorAllocate (0, 0, 255);
$red = $image->colorAllocate (255, 0, 0);

$image->rectangle (0, 0, $image_length - 1, $image_height - 1, $blue);

for ($loop=0; $loop <= ($count_length - 1); $loop++) {
	$number = substr ($no_visitors, $loop, 1);

	if ($count_length > 1) {

		$temp_x = ($font_length + $distance) * ($loop + 1);

		$image->line ( $temp_x, 0, $temp_x, $image_height, $blue );
	}

$image->char ( gdLargeFont, ($border / 2) + ($font_length * $loop) + ($loop * $distance), $distance, $number, $red );
}

print "Content-type: image/gif", "\n\n";
print $image->gif;
}

sub return_error
{
	local ($status, $keyword, $message) = @_;

	print "Content-type: text/html", "\n";
	print "Status: ", $status, " ", $keyword, "\n\n";

	print <<End_of_Error;

<title>CGI Program - Unexpected Error</title>
<h1>$keyword</h1>
<hr>$message</hr>
Please contact $webmaster for more information.

End_of_Error

	exit (1);
}