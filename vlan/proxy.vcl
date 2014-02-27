sub vcl_recv {


#	## Choix du Backend
        if (
		req.url == "/" ||
		req.url ~  "(?i)^/metriweb/" || 
                req.url ~ "(?i)^/(fr|nl|en)(/|$)" ||
                req.url ~ "(?i)^/(css|js|images|shadowbox|scripts)(/|$)" 
	   ) {
             set req.backend = portalvlan;
# (pour install)             set req.backend = default;
             }

}
