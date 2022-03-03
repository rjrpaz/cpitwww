#!/usr/bin/perl

print "Content-type: text/html", "\n\n";

$webmaster = "root";

($seconds, $minutes, $hour) = localtime (time);

if ( ($hour >=23) || ($hour <=6) ) {
	$greeting = "Es tarde, no?";
} elsif ( ($hour > 6) && ($hour < 12) ) {
	$greeting = "Buenos Dias";
} elsif ( ($hour >= 12) && ($hour <= 18) ) {
	$greeting = "Buenas Tardes";
} else {
	$greeting = "Buenas Noches";
}

if ($hour > 12) {
	$hour -= 12;
} elsif ($hour == 0) {
	$hour = 12;
}

$time = sprintf ("%02d:%02d:%02d", $hour, $minutes, $seconds);

open (CHECK, "/usr/bin/w -h -s $webmaster |");

if (<CHECK> =~ /$webmaster/) {
	$in_out = "Ya estoy logeado";
} else {
	$in_out = "I just stepped out?";
}
close (CHECK);

print <<End_of_Homepage;
<HTML>
<HEAD><TITLE>Bienvenido a mi pagina</TITLE></HEAD>
<BODY>
$greeting!
<P>
$time
<P>
<ADDRESS>
Cacho Carmona ($in_out)
</ADDRESS>

</BODY></HTML>

End_of_Homepage

exit (0);
