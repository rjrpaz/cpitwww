#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void main (void)
{
	char *http_user_agent;
	
	printf ("content-type: text/plain\n\n");
	http_user_agent = getenv ("HTTP_USER_AGENT");
	
	if (http_user_agent == NULL) {
		printf ("Tu browser no invoca la variable HTTP_USER_AGENT");
	} else if (!strncmp (http_user_agent, "Mosaic", 6)) {
		printf ("Estas usando el original \n");
	} else if (!strncmp (http_user_agent, "Mozilla", 7)) {
		printf ("Estas usando Netscape Navigator \n");
	} else if (!strncmp (http_user_agent, "Lynx", 4)) {
		printf ("Estas usando Lynx \n");
	} else {
		printf ("Estas usando %s. \n", http_user_agent);
		}
	exit (0);
}