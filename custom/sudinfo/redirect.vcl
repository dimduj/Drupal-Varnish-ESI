/**
 * 301 Redirect (Moved Permanently)
 */
sub redirect_301 {

    if ( req.url ~ "^/node$" ) { error 701 "/"; }

	if (req.http.Host == "www.sudexpress.be" || req.http.Host == "sudexpress.be" || req.http.Host == "www.sudxpress.be" || req.http.Host == "sudxpress.be") {
                error 701 "http://www.sudinfo.be/sudxpress";
	}
	elsif (req.http.Host == "www.jemabonne.be" || req.http.Host == "jemabonne.be" || req.http.Host == "www.abonnetoi.be" || req.http.Host == "abonnetoi.be") {
                error 701 "http://num.sudinfo.be/services/abonnement/";
	}
	elsif (req.http.Host == "boutique.sudpresse.be" || req.http.Host == "boutique.lameuse.be" || req.http.Host == "boutique.laprovince.be" || req.http.Host == "boutique.nordeclair.be" || req.http.Host == "boutique.lanouvellegazette.be" || req.http.Host == "boutique.lacapitale.be" || req.http.Host == "www.laboutiqueenligne.be" || req.http.Host == "laboutiqueenligne.be" || req.http.Host == "www.boutiqueenligne.be" || req.http.Host == "boutiqueenligne.be") {
                error 701 "http://boutique.sudinfo.be/";
	}
	elsif (req.http.Host == "photobook.sudpresse.be" || req.http.Host == "photobook.sudinfo.be" || req.http.Host == "photobook.lameuse.be" || req.http.Host == "photobook.lanouvellegazette.be" || req.http.Host == "photobook.laprovince.be" || req.http.Host == "photobook.lacapitale.be" || req.http.Host == "photobook.nordeclair.be") {
                error 701 "http://www.photobook.be/sudpresse/";
	}
}

/**
 * 302 Redirect (Found)
 */
sub redirect_302 {
    #if (req.http.Host == "www.lesoirimmo.be" || req.http.Host == "lesoirimmo.be" || req.http.Host == "www.lesoirimmo.com" || req.http.Host == "lesoirimmo.com" || req.http.Host == "www.soirimmo.be" || req.http.Host == "soirimmo.be" || req.http.Host == "www.soirimmo.com" || req.http.Host == "soirimmo.com" || req.http.Host == "decoimmo.be" || req.http.Host == "www.decoimmo.be" || req.http.Host == "decoimmo.com" || req.http.Host == "www.decoimmo.com") {
      #  error 702 "http://www.lesoir.be/actu/economie/immo-99";
    #}
}

/**
 * On gere les codes 701 / 702 pour les redirects. Ce sont des erreurs custom inventées pour pouvoir gérer les redirect car on ne peut le faire que dans ERROR
 */
sub redirect_error {
	#
    if (obj.status == 701) {
        set obj.http.Location = obj.response;
        set obj.status = 301;
        return(deliver);
    }

	# 
    if (obj.status == 702) {
        set obj.http.Location = obj.response;
        set obj.status = 302;
        return(deliver);
    }


}
