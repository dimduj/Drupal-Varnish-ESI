##
# serve slightly stale objects if the backend is busy or sick
##

sub vcl_recv {
	# if requests for the same object pile up,
	# serve expired cacheable objects for 3m
	if (req.backend.healthy) {
		set req.grace = 3m;
	} else {
		# if the backend is down,
		# serve expired cacheable objects for 1h
		# requires backend probes
		set req.grace = 1h;
	}
}

sub vcl_fetch {
	# keep old objects in cache for 1h after expiry
	# allows use of grace in vcl_recv()
	set beresp.grace = 1h;
}
