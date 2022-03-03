#!/usr/bin/perl

$webmaster = "shishir\@bu\.edu";
$document_root = "/var/lib/httpd/htdocs";
$ice_cream_file = "/ice_cream.dat";
$full_path = $document_root . $ice_cream_file;

$exclusive_lock = 2;
$unlock = 8;

&parse_form_data(*poll);
$user_selection = $poll{'ice_cream'};

if ( open (POLL, "<" . $full_path) ) {
	flock (POLL, $exclusive_lock);

	for ($loop=0; $loop < 3; $loop++) {
		$line[$loop] = <POLL>;
		$line[$loop] =~ s/\n$//;
	}

	@options = split("::", $line[0]);
	@data = split ("::", $line[1]);
	$colors = $line[2];

	flock (POLL, $unlock);
	close (POLL);

	$item_no = 3;
	for ($loop=0; $loop <= $#options; $loop++) {
		if ($options[$loop] eq $user_selection) {
			$item_no = $loop;
			last;
		}
	}

	$data[$item_no]++;


	if ( open (POLL, ">" . $full_path) ) {
		flock (POLL, $exclusive_lock);

		print POLL join ("::", @options), "\n";
		print POLL join ("::", @data), "\n";
		print POLL $colors, "\n";

		flock (POLL, $unlock);
		close (POLL);

		print "Content-type: text/html", "\n\n";

		print <<End_of_Thanks;
<HTML>
<HEAD><TITLE>Gracias!</TITLE></HEAD>
<BODY>
<H1> gracias!</H1>
	<HR>
	Gracias por participar en la encuesta. Si desea ver los resultados, clickee 
 <A HREF="/cgi/pie.pl${ice_cream_file}">aqui</A>.
</BODY></HTML>

End_of_Thanks

		} else {
			&return_error (500, "Ice Cream Poll File Error", "Cannot write to poll data file [$full_path].");
		}
	
	} else {
		&return_error (500, "Ice Cream Poll File Error", "Cannot read from the poll data file [$full_path].");
	}

	exit (0);


sub parse_form_data
{
	local (*FORM_DATA) = @_;

	local ( $request_method, $post_info, @key_value_pairs, $key_value,
$key, $value);

	read (STDIN, $post_info, $ENV{'CONTENT_LENGTH'});

	@key_value_pairs = split (/&/, $post_info);

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

