sub vcl_recv {

	if ( req.http.host ~ "(?i)^activation(.*)\.vlan\.be") {
		set req.backend = default;
	} else {
		## Choix du Backend
		if (
			req.url == "/" ||
			req.url ~  "(?i)^/metriweb/" || 
			req.url ~ "(?i)^/(fr|nl|en|integration|xsd)(/|$)" ||
			req.url ~ "(?i)^/(css|js|images|shadowbox|scripts)(/|$)" 
		   ) {
			set req.backend = portalvlan;
			# (pour install) set req.backend = default;
		}
	}

	## Special Url Alias (home page).
	if (req.url ~ "(?i)^/acheter-malin\.html$") {
		set req.url = "/";
		set req.backend = default;
	}

}
