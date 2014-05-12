sub vcl_recv {

	if ( req.http.host ~ "(?i)^special-crafted-url(.*)\.a-host\.be") {
		set req.backend = default;
	} else {
		## Choix du Backend
		if (
			req.url == "/" ||
			req.url ~  "(?i)^/metriweb/" || 
			req.url ~ "(?i)^/(fr|nl|en|integration|xsd)(/|$)" ||
			req.url ~ "(?i)^/(css|js|images|shadowbox|scripts)(/|$)" 
		   ) {
			set req.backend = portallegacy;
			# (pour install) set req.backend = default;
		}
	}

	## Special Url Alias (home page).
	if (req.url ~ "(?i)^/another-special-crafted-url\.html$") {
		set req.url = "/";
		set req.http.host = "example-another-host.com";
		set req.backend = default;
	}

}
