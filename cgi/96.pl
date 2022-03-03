#!/usr/bin/perl

@URL = ("http://www.ora.com", "http://www.digital.com", "http://www.ibm.com", "http://www.radius.com");

srand (time | $$);

$number_of_URL = $#URL;
$number_of_URL++;
$random = int (rand ($number_of_URL));

$random_URL = $URL[$random];

print "Content type: text/plain", "\n\n";

print $number_of_URL;
print qq|<A HREF="$random_URL">Clickee aqui por un sitio aleatorio</A>|,
"\n";

exit (0);
