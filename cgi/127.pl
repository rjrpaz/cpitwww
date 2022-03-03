#!/usr/bin/perl

$webmaster = "shishir\@bu\.edu";
$gnuplot = "/usr/bin/gnuplot";
$ppmtojpeg = "/usr/bin/cjpeg"; 
$access_log = "/var/lib/httpd/logs/access_log";

$process_id = $$;
$output_ppm = join ("", "/tmp/", $process_id, ".ppm");
$datafile = join ("", "/tmp/", $process_id, ".txt");

$x = 0.6;
$y = 0.6;
$color = 1;

if ( open (FILE, "<" . $access_log) ) {
	for ($loop=0; $loop < 24; $loop++) {
	$time[$loop] = 0;
}

while (<FILE>) {
	if (m|\[\d+/\w+/\d+:([^:]+)|) {
		$time[$1]++;
	}
}
close (FILE);

&create_output_file();

} else {
	&return_error (500, "Server Log File Error", "Cannot open NCSA
server access log!");
}

exit (0);

sub create_output_file
{
	local($loop);
	if ( (open (FILE, ">" . $datafile)) ) {
		for ($loop=0; $loop < 24; $loop++) {
		print FILE $loop, " ", $time[$loop], "\n";
		}
		close (FILE);

		&send_data_to_gnuplot();
	} else {
		&return_error (500, "server log file error", "cannot write
to data file!");
}
}

sub send_data_to_gnuplot
{
	open (GNUPLOT, "|$gnuplot");
	print GNUPLOT <<gnuplot_Commands_Done;

	set term pbm color small
	set output "$output_ppm"
	set size $x $y
	set title "WWW server usage"
	set xlabel "Time (Hours)"
	set ylabel "No. of Requests"
	set xrange [-1:24]
	set xtics 0, 2, 23
	set noxzeroaxis
	set noyzeroaxis
	set border
	set nogrid
	set nokey
	plot "$datafile" w boxes $color

gnuplot_Commands_Done

close (GNUPLOT);

	&print_gif_file_and_cleanup();
}
	
sub print_gif_file_and_cleanup()
{
$| = 1;
print "Content-type: image/jpeg", "\n\n";
system ("$ppmtojpeg $output_ppm 2> /dev/null");

unlink $output_ppm, $datafile;
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