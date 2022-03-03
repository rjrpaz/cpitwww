#!/usr/bin/tclsh

puts "Content-type: text/plain\n"

set http_accept $env(HTTP_ACCEPT)
set browser $env(HTTP_USER_AGENT)

puts "Esta es una lista de los MIME types que el cliente acepta"
puts "debido a que usa $browser:\n"

set mime_types [split $http_accept ,]

foreach type $mime_types {
	puts "- $type"
}

exit 0