backend default {
	.host = "10.2.4.36";
	.port = "8083";
	.max_connections = 200;
}

backend portalvlan {
#	.host = "portal.vlan.be";
        .host = "185.18.10.87";
	.port = "80";
	.max_connections = 200;
}


sub vcl_recv {
     set req.backend = default;
}
