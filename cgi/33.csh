#!/bin/csh

echo "Content-type: text/plain"
echo ""

if ($?QUERY_STRING) then
	set command = `echo $QUERY_STRING | awk 'BEGIN {FS = "="} {print $2 }'`

	if ($command == "fortune") then
		/usr/games/fortune
	else if ($command == "finger") then
		/usr/bin/finger
	else
		/bin/date
	endif

else
	/bin/date
endif