#!/usr/bin/perl

#Para apreciar bien el funcionamiento de este script, debemos recargar la
#pagina con el browser (reload), porque aparentemente queda en el cache

use GD;

$| = 1;
$webmaster = "shishir\@bu\.edu";

print "Content-type: image/gif", "\n\n";

&parse_form_data (*color_text);
$message = $color_text{'message'};
$color = $color_text{'color'};

#print "Content-type: text/plain", "\n\n";
#print "  ",$message;

if (!$message) {
	$message = "Este es un ejemplo de ". $color . "texto";
}

$font_length = 16;
$font_height = 32;
$length = length ($message);

$x = $length * $font_length;
$y = $font_height;

$image = new GD::Image ($x, $y);

$white = $image->colorAllocate (255, 255, 255);

if ($color eq "Red") {
	@color_index = (255, 0, 0);
} elsif ($color eq "Blue") {
	@color_index = (0, 0, 255);
} elsif ($color eq "Green") {
	@color_index = (0, 255, 0);
} elsif ($color eq "Yellow") {
	@color_index = (255, 255, 0);
} elsif ($color eq "Orange") {
	@color_index = (255, 165, 0);
} elsif ($color eq "Purple") {
	@color_index = (160, 32, 240);
} elsif ($color eq "Brown") {
	@color_index = (165, 42, 42);
} elsif ($color eq "Black") {
	@color_index = (0, 0, 0);
}

$selected_color = $image->colorAllocate (@color_index);
$image->transparent ($white);

$image->string (gdLargeFont, 0, 0, $message, $selected_color);
print $image->gif;

exit (0);

sub parse_form_data
{
local (*FORM_DATA) = @_;

local ( $request_method, $query_string, @key_value_pairs, $key_value, $key, $value);

$request_method = $ENV{'REQUEST_METHOD'};

if ($request_method eq "GET") {
	$query_string = $ENV{'QUERY_STRING'};
} elsif ($request_method eq "POST") {
	read (STDIN, $query_string, $ENV{'CONTENT_LENGTH'});
} else {
	&return_error (500, "Server Error", "server user unsupported method");
}

@key_value_pairs = split (/&/, $query_string);

foreach $key_value (@key_value_pairs) {
	($key, $value) = split (/=/, $key_value);
	$value =~ tr/+/ /;
	$value =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack ("C", hex ($1))/eg;

	if (defined($FORM_DATA{$key})) {
		$FORM_DATA{$key} = join ("\0", $FORM_DATA{$key}, $value);
	} else {
		$FORM_DATA{$key} = $value;
	}
}
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