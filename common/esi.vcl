##
# advertise ESI capabilities, handle ESI responses
##

sub vcl_recv {
	# advertise ESI capabilities to backend
	set req.http.Surrogate-Capability = "varnish=ESI/1.0";
}

sub vcl_fetch {
	# handle ESI 

    //todo: check if we should allow ESI here (what about static ?)
	if (! req.url ~ "^[^?]*\.(png|jpg|gif|css|js|swf|flv|ico|xml|txt|pdf|doc|woff|eot|mp[34])(\?.*)?$") {
		set beresp.do_esi = true;
	}

    
    

	## TODO: really parse control header. see http://www.w3.org/TR/edge-arch
	if (beresp.http.Surrogate-Control ~ "ESI/1.0") {
		unset beresp.http.Surrogate-Control;
		set beresp.do_esi = true;
	}
}

