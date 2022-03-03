#!/usr/bin/perl

$webmaster = "shishir\@bu\.edu";
&parse_form_data (*simple_form);

print "Content type: text/plain", "\n\n";
$user = $simple_form{'user'};

if ($user) {
	print "Encantado de verlo ", $simple_form{'user'}, ".", "\n";
	print "Visite este servidor cuando quiera", "\n";
} else {
	print "No ingresaste un nombre, verdad?", "\n";
}

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