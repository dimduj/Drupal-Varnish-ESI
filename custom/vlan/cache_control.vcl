sub vcl_deliver {

    # Ajout de caches browser pour ce qui est servis. 
    if (req.url ~ "(?i)\.(png|gif|jpeg|jpg|ico|swf|css|js|pdf)(\?[a-z0-9]+)?$" ) {
		if (req.url ~ "(?i)\.(ico|css|js|pdf)(\?[a-z0-9]+)?$") {
			set resp.http.Cache-Control = "max-age=14400, public";
        } else {
            set resp.http.Cache-Control = "max-age=7200, public";
        }
    } else {
		set resp.http.Cache-Control = "max-age=" + req.http.X-CacheTtl + ", public";
    }

}
