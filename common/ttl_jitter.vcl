##
# vary the TTL, so that objects don't expire all at the same time
#
# requires std vmod
##

# import std;


# on fair une repartition des TTL pour eviter des pic au niveau du varnish

sub vcl_fetch {
	if (beresp.ttl > 0s) {
		set beresp.ttl = beresp.ttl * std.random(0.8, 1.0);
	}
}
