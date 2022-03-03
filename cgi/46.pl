#!/usr/bin/perl

chop ($current_date = `/bin/date`);
$script_name = $ENV{'SCRIPT_NAME'};

print "Content-type: text/html", "\n\n";
print "<HTML>", "\n";
print "<HEAD><TITLE>Efectos del cache del browser</TITLE></HEAD>", "\n";
print "<BODY><H1>", $current_date, "</H1>", "\n";
print "<P>", qq|<A HREF="$script_name">Clickee aqui para correr nuevamente</A>|, "\n";
print "</BODY></HTML>", "\n";

exit (0);
