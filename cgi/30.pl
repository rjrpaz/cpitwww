#!/usr/bin/perl

$size_of_form_information = $ENV{'CONTENT_LENGTH'};
read (STDIN, $form_info, $size_of_form_information);

$form_info =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack ("C", hex ($1))/eg;

($field_name, $birthday) = split (/=/, $form_info);

print "Content-type: text/plain", "\n\n";

print "Tu cumpleanios es el: $birthday. Eso es lo que me dijiste, no?", "\n";

exit (0);