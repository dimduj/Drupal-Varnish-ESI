
sub vcl_hash {

	  # Pour ces URLS soit les parametre sont intéressants a garder en cache
	  # soit il y en a trop pour etre tous vérifiés. (LAZY MODE)
	  # c'est EMPIRIQUE ... faut donc compter sur l'expérience et la communication
	  # avec les équipes de dev. 

	  if(req.request == "GET" && !req.url ~ "^(e|api|ad") {

		set req.http.X-Sanitized-URL = req.url;

		# On dégage tout les params qui ne sont pas dans la regex suivante
		set req.http.X-Sanitized-URL = regsuball(req.http.X-Sanitized-URL, "[&|\?]+(?!\b(?:page|q)\b).*?=?[^&\r\n]*", "");
		if(!req.http.X-Sanitized-URL ~ "\?" && req.http.X-Sanitized-URL ~ "&"){
		  set req.http.X-Sanitized-URL = regsub(req.http.X-Sanitized-URL,"&","?");
		}
		hash_data(req.http.X-Sanitized-URL);
		set req.http.X-CacheHash = req.http.X-Sanitized-URL;
	  } else {
		# on est dans le cas des URLs de la liste ci dessus, on cache avec tous les parametres. 
		hash_data(req.url);
		set req.http.X-CacheHash = req.url;
	  }

	  hash_data(req.http.host);
	  set req.http.X-CacheHash = req.http.X-CacheHash + req.http.host;

	  return (hash);
}


sub vcl_deliver {

    ## Ajout de l'url sanétisée dans l'entete.
   if(req.http.X-Sanitized-URL){
		set resp.http.X-Sanitized-URL = req.http.X-Sanitized-URL;
    } 

}
