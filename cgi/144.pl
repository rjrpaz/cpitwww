#!/usr/bin/perl

$webmaster = "shishir\@bu\.edu";
$method = $ENV{'REQUEST_METHOD'};
$script = $ENV{'SCRIPT_NAME'};
$query = $ENV{'QUERY_STRING'};

$document_root = "/var/lib/httpd/htdocs";
$guest_file = "/guestbook.html";
$full_path = $document_root . $guest_file;

$exclusive_lock = 2;
$unlock = 8;

if ($method eq "GET") {
	if ($query eq "add") {

$date_time = &get_date_time();

&MIME_header ("text/html", "Cacho Guestbook");

print <<End_Of_Guestbook_Form;

Este es un script en CGI que permite dejar cierta informacion
la cual puede ser consultada por otros. Por favor, ingrese los 
datos que se piden a continuacion, <B>y<B> si posee un servidor
de WEB, ingrese la direccion para que un link sea creado.
<P>
El tiempo actual es: $date_time
<HR>
<FORM METHOD="POST">
<PRE>
<EM> Nombre Completo</EM>:	<INPUT TYPE="text" NAME="name" SIZE=40>
<EM> E-mail</EM>:		<INPUT TYPE="text" NAME="from" SIZE=40>
<EM> Servidor de WWW</EM>:	<INPUT TYPE="text" NAME="www" SIZE=40>
</PRE>
<P>
<EM>Ingrese la informacion que desee agregar:</EM><BR>
<TEXTAREA ROWS=3 COLS=60 NAME="comments"></TEXTAREA><P>
<INPUT TYPE="submit" VALUE="Agregar al libro de Visitas">
<INPUT TYPE="reset" VALUE="Limpiar la informacion"><BR>
<P>
</FORM>
<HR>

End_Of_Guestbook_Form

	} else {
if ( open(GUESTBOOK, "<" . $full_path) ) {
	flock (GUESTBOOK, $exclusive_lock);

	&MIME_header ("text/html", "libro de visitas");

	while (<GUESTBOOK>) {
		print;
	}

	flock (GUESTBOOK, $unlock);
	close (GUESTBOOK);

	} else {
		&return_error (500, "Guestbook File Error", "no puedo leer
el archivo [$full_path].");
	}
}

} elsif ($method eq "POST") {
	if ( open (GUESTBOOK, ">>" . $full_path) ) {
		flock (GUESTBOOK, $exclusive_lock);

		$date_time = &get_date_time();
		&parse_form_data (*FORM);

		$FORM{'name'} = "Usuario Anonimo"	if !$FORM{'name'};
		$FORM{'from'} = $ENV{'REMOTE_HOST'}	if !$FORM{'from'};
		$FORM{'comments'} =~ s/\n/<BR>/g;

		print GUESTBOOK <<End_Of_Write;

<P>
<B>$date_time: </B><BR.
Mensaje desde <EM>$FORM{'name'}</EM> at <EM>$FORM{'from'}</EM>:
<P>
$FORM{'comments'}

End_Of_Write

	if ($FORM{'www'}) {
		print GUESTBOOK <<End_Of_Web_Address;

<P>
$FORM{'name'} puede ser encontrado en:
<A HREF="$FORM{'www'}">$FORM{'www'}</A>

End_Of_Web_Address

	}

	print GUESTBOOK "<P><HR>";

	flock (GUESTBOOK, $unlock);
	close (GUESTBOOK);

	&MIME_header ("text/html", "Gracias");

	print <<End_of_Thanks

Gracias por visitar mi libro de visitas. Si desea consultar el mismo,
debe clickear <A HREF="$guest_file"> aqui</A> (Archivo de visitas actual),
o bien <A HREF="$script">aqui</A> (script de visitas sin requerimiento).

End_of_Thanks

	} else {
		&return_error (500, "Error en el archivo", "No se puede
escribir en el archivo [$full_path].")
	}
} else {
	&return_error (500, "Error en el servidor", "server uses unsuported
method");
}
exit (0);

sub MIME_header
{
	local ($mime_type, $title_string, $header) = @_;

	if (!$header) {
		$header = $title_string;
	}

	print "Content-type: ", $mime_type, "\n\n";
	print "<HTML>", "\n";
	print "<HEAD><TITLE>", $title_string, "</TITLE></HEAD>", "\n";
	print "<BODY>", "\n";
	print "<H1>", $header, "</H1>";
	print "<HR>";
}

sub get_date_time
{
	local ($months, $weekdays, $ampm, $time_string);
	$months = "January/February/March/April/May/June/July/" .
		"August/September/October/November/December";
	$weekdays = "Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday";

	local ($sec, $min, $hour, $day, $nmonth, $year, $wday, $yday, $isdst) = localtime (time);

	if ($hour > 12) {
		$hour -= 12;
		$ampm = "pm";
	} else {
		$ampm = "am";
	}

	if ($hour == 0) {
		$hour = 12;
	}

	$year += 1900;

	$week = (split("/", $weekdays))[$wday];
	$month = (split("/", $months))[$nmonth];

	$time_string = sprintf("%s, %s %s, %s = %02d:%02d:%02d %s", $week,
				$month, $day, $year, $hour, $min, $sec,
				$ampm);

	return ($time_string);
}

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

