backend default {
	.host = "127.0.0.1";
	.port = "8083";
	.max_connections = 200;
}

backend portalvlan {
	.host = "portal.vlan.be";
	.port = "80";
	.max_connections = 200;
}
