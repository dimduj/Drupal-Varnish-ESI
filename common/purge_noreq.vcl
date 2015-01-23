##
# implement PURGE with regex in URL and Host: header
#
# purge without referencing req
# allows use of ban lurker
# see http://kly.no/posts/2010_07_28__Smart_bans_with_Varnish__.html
#
# requires ACL purge
##

# @todo:  WHAT THE HELL ? WHY this fetch ?
# we use variable in receive that will be set after in the  fetch ??? 

sub vcl_fetch {
	set beresp.http.X-Purge-URL = req.url;
	set beresp.http.X-Purge-Host = req.http.host;
}

sub vcl_deliver {
	unset resp.http.X-Purge-URL;
	unset resp.http.X-Purge-Host;
}

sub vcl_recv {
	if (req.request == "PURGE") {
		if (!client.ip ~ purge) {
			error 405 "Not allowed.";
		}
		# obj.http.X-Purge-Host => on fait la requete par rapoort au host varnish (on purge pas tout les user/1 de tte les instances)
		# On prefere la commande ban à la commande purge
		ban("obj.http.X-Purge-URL ~ " + req.url + " && obj.http.X-Purge-Host ~ " + req.http.host);
		error 200 "Added to ban list";
	}
}
