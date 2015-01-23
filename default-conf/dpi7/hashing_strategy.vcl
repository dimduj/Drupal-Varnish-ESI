
sub vcl_hash {

	  # Pour ces URLS soit les parametre sont intéressants a garder en cache
	  # soit il y en a trop pour etre tous vérifiés. (LAZY MODE)
	  # c'est EMPIRIQUE ... faut donc compter sur l'expérience et la communication
	  # avec les équipes de dev. 

	  if(req.request == "GET" ) {

		set req.http.X-Sanitized-URL = req.url;

		# On dégage tout les params qui ne sont pas dans la regex suivante
		# on remplace tout ce qui match pas la regex par "" dans les 
		
		#ex: ?page=1&toto=2 => ?page=1
		#ex2: ?toto=2&page=1 => &page=1
		
		#set req.http.X-Sanitized-URL = regsuball(req.http.X-Sanitized-URL, "[&|\?]+(?!\b(?:page|q)\b).*?=?[^&\r\n]*", "");
		#if(!req.http.X-Sanitized-URL ~ "\?" && req.http.X-Sanitized-URL ~ "&"){
		
    	  #ex2: &page=1=>?page=1
		#  set req.http.X-Sanitized-URL = regsub(req.http.X-Sanitized-URL,"&","?");
		#}
		
		hash_data(req.http.X-Sanitized-URL);
		
		set req.http.X-CacheHash = req.http.X-Sanitized-URL;
	  } else {
		# on est dans le cas des URLs de la liste ci dessus, on cache avec tous les parametres. 
		hash_data(req.url);
		set req.http.X-CacheHash = req.url;
	  }


	  #@todo: rename or remove req.http.X-CacheHash . It appear to be useless
	  hash_data(req.http.host);
	  
	  #@todo: dont need this anymore since we do that on deliver of dpi7.vcl
	  //set req.http.X-CacheHash = req.http.X-CacheHash + req.http.host;

	  return (hash);
}


sub vcl_deliver {

    ## Ajout de l'url sanétisée dans l'entete.
   if(req.http.X-Sanitized-URL){
		set resp.http.X-Sanitized-URL = req.http.X-Sanitized-URL;
    } 
    
    set resp.http.X-hash = req.http.X-CacheHash;


}
