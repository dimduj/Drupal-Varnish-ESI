##
# implement varnish-ping for load balancers
##

sub vcl_recv {
	if (req.url ~ "^varnish-ping$") {
		error 200 "Pong - ping-pong is a sport in which two or four players hit a lightweight ball back and forth using a table tennis racket";
	}
}

