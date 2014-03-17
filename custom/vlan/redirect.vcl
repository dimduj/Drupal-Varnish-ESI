sub vcl_recv {

	## Need /common/vcl_error.vcl 
	
	if ( req.http.host ~ "(?i)^activation(.*)\.vlan\.be" && req.url != "") {
		error 751 "http://www.vlan.be/" + req.url;
	} 
}
