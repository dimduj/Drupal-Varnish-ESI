backend default {
	.host = "activation-stage.vlan.be";
	.port = "8083";
	.max_connections = 200;
}

backend portalvlan {
	.host = "portal.vlan.be";
	.port = "80";
	.max_connections = 200;
}


sub vcl_recv {
     set req.backend = default;
}
