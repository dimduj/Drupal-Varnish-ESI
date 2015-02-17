## --------------------------------------------------------------------
# varnish configuration
## --------------------------------------------------------------------

## built-in standard library - https://www.varnish-cache.org/docs/trunk/reference/vmod_std.html
import std;
## GeoIP lookup functions - https://github.com/lampeh/libvmod-geoip
#import geoip;
## header-modification vmod - https://github.com/varnish/libvmod-header
#import header;
## digest and HMAC vmod - https://github.com/varnish/libvmod-digest
#import digest;
## cURL bindings for Varnish - https://github.com/varnish/libvmod-curl
#import curl;
## variable support vmod - https://github.com/varnish/libvmod-var
#import var;


## --------------------------------------------------------------------
## ACLS
## --------------------------------------------------------------------

# Define a set of rules (regarding Ip adresse etc) to allow actions (purge, ban, GET)

include "default-conf/dpi7/acl/acl_httpsproxy.vcl";
#include "default-conf/dpi7/acl/acl_extcache.vcl";
#include "default-conf/dpi7/acl/acl_freshforce.vcl";
include "default-conf/dpi7/acl/acl_purge.vcl";

## --------------------------------------------------------------------
## helper functions
## --------------------------------------------------------------------

## load sub routine "remove_cacheblock_beresp" to remove cache-blocking headers from backend response
include "common/sub_remove_cacheblock_beresp.vcl";


## Detect device
#include "common/device_detect.vcl";

## --------------------------------------------------------------------
## common snippets (activate as needed)
## --------------------------------------------------------------------

## PURGE requests
## purge.vcl is simple purge with VCL.
## purge_noreq.vcl is a friendly ban-lurker implementation of purge
## prefer purge_noreq.vcl
#include "common/purge.vcl";
include "common/purge_noreq.vcl";

## reject /w00tw00t requests
include "common/no_w00t.vcl";

## force a cache miss if the client sets an "X-FreshForce: yes" header
#WARNING check your ACL before activate this feature
#include "common/freshforce_header.vcl";

## force a cache miss if the client address matches the freshforce acl
#include "common/freshforce_clientip.vcl";

## force a cache miss if the user agent matches "Googlebot"
#include "common/freshforce_googlebot.vcl";

## add "Connection: close" to piped requests
include "common/pipe_close.vcl";

## return 302 or 301 redirect from VCL
include "common/redirect.vcl";

## Restart on 503 - 
# si on recoit une 503 on reessaye trois fois de plus (nbre de round robin +1) avant de reelement renvoyer 503 au client
#@todo: check compatibility with drupal ESI per ROLE/USER/... since ESI aslo do restart ? check)
#include "common/error_restart.vcl";

## repair weird request format "GET http://host/path"
#@todo: Remove temporary cause issue with ESI ? => seems not ... :/
include "common/normalize_http.vcl";

## allow "HTTPS:" header from SSL proxies only
include "common/http_https.vcl";

## avoid stall if a request loops back from another cache
#include "common/extcache_ignorebusy.vcl";

## fake Age: header for objects where ttl > max-age
include "common/fake_age.vcl";

## remove cookies from requests for static files
include "common/cookie_remove_static.vcl";

## remove Google Analytics cookies from request
include "common/cookie_remove_ga.vcl";

## remove Cloudflare cookies from request
#include "common/cookie_remove_cloudflare.vcl";

## remove expires header from static files, add "public" to Cache-Control
include "common/expire_remove_static.vcl";

## advertise ESI, handle ESI responses
include "common/esi.vcl";

## set object TTL from Cache-Control: v-maxage attribute
include "common/ttl_v-maxage.vcl";

## vary TTL to avoid clustering of expired objects
include "common/ttl_jitter.vcl";

## GeoIP lookup: add X-Country-Code to request header
#include "common/geoip_lookup.vcl";

## Only "GET" && "HEAD" && "POST" 
## Always cache PASS for "htttp authorisation"
include "common/method_allowed.vcl";

## grace and saintmode
include "experimental/grace.vcl";
include "experimental/saintmode.vcl";

## Varnish-ping for loadbalancers above varnish (F5)
include "common/ping.vcl";

## X Forwarded For (proxy)
# We bind client adress IP
include "common/x_forwarded_for.vcl";

## --------------------------------------------------------------------
## custom code here for Drupal 7
## --------------------------------------------------------------------

## Drupal Common : Forbidden Files
include "drupal/forbidden_url_d7.vcl";

## --------------------------------------------------------------------
## custom code here for your Drupal 7 website
## --------------------------------------------------------------------


#include "default-conf/dpi7/proxy/proxy.vcl";


include "default-conf/dpi7/esi/dpi7-esi.vcl";

#include "default-conf/dpi7/dpisso/dpisso.vcl";

## --------------------------------------------------------------------
## Below is a copy of the default VCL logic.
## The built-in logic will be appended to your code.
## --------------------------------------------------------------------

sub vcl_recv {




   ## We only deal with GET and HEAD by default
   if (req.request != "GET" && req.request != "HEAD") {
   #pass= pour cette requete, on outrepasse la cache. ! on est déjà passer par common/method_allowed.vcl
   #@todo: remove POST request from dorce close pipe
   #
		return (pipe);
   }

   
   ## Gestion du temps de grace
   ## Temps pendant lequel on continue à servir le contenu
   ## en cache même s'il est périmé.
   #redondant avec les experimental/grace.vcl
   #pas tres logique ... :/ pcq pas la page mais les images :/
   set req.grace = 6m;
   if (req.request == "GET" && req.url ~ "(?i)\.(png|gif|jpeg|jpg|ico|swf|css|js|html|htm|txt|zip|svg|xml)/?(\?.*)?$") { 
		set req.grace = 2h;
   } 
   

   ## Retrait des lignes de l'entete http inutiles.
   if (req.request == "GET" && req.url !~ "(?i)\.(png|gif|jpeg|jpg|ico|swf|css|js|html|htm|txt|zip|svg|xml)/?(\?.*)?$") {
		remove req.http.If-None-Match;
   }
    
   return (lookup);
}

## --------------------------------------------------------------------
## 
## --------------------------------------------------------------------
sub vcl_pipe {
    # Note that only the first request to the backend will have
    # X-Forwarded-For set.  If you use X-Forwarded-For and want to
    # have it set for all requests, make sure to have:
    # set bereq.http.connection = "close";
    # here.  It is not set by default as it might break some broken web
    # applications, like IIS with NTLM authentication.
    return (pipe);
}

## --------------------------------------------------------------------
## 
## --------------------------------------------------------------------
sub vcl_pass {
    return (pass);
}



## --------------------------------------------------------------------
##  
## --------------------------------------------------------------------

include "default-conf/dpi7/hashing_strategy.vcl";

sub vcl_hash {
    return (hash);
}

## --------------------------------------------------------------------
## 
## --------------------------------------------------------------------
#We do that to obtain it on the delivery ...
sub vcl_hit {
	set req.http.X-CacheTtl = obj.ttl; 
    return (deliver);
}

## --------------------------------------------------------------------
## 
## --------------------------------------------------------------------
sub vcl_miss {
    return (fetch);
}

## --------------------------------------------------------------------
## 
## --------------------------------------------------------------------
sub vcl_fetch {


    ///@todo: do only esi for php page not static ressource
    set beresp.do_esi = true;

    call remove_cacheblock_beresp;

	## TTL et temps de grace par defaut  
	set beresp.ttl = 1h;
	set beresp.grace = 2h;

	## Pour les fichiers, on augmente volontiers le temps de mise en cache
	if (req.url ~ "^/sites/default/files/" || req.url ~ "(?i)\.(png|gif|jpe?g|ico|txt|swf|css|js|pdf|zip|wav|avi|svg)/?(\?.*)?") {
		unset beresp.http.set-cookie;
		set beresp.ttl = 6h;
		set beresp.grace = 24h;
	}

	## On gere en fonction des status HTTP retournés
	if (beresp.status == 404) {
	#WARNING NEVER pass cookie unless you will log someone else ;)
		unset beresp.http.set-cookie; 
		set beresp.ttl = 12h; 
		return(deliver);
	}
	elsif(beresp.status == 301){
		unset beresp.http.set-cookie; 
		set beresp.ttl = 1h;
		return(deliver);
	}
	elsif (beresp.status >= 500) { 
	
		if (req.url ~ "(?i)\.(png|gif|jpeg|jpg|ico|swf|css|js|pdf|zip|wav|avi)/?(\?.*)?$") { 
			set beresp.saintmode = 24h;
		} else { 
		  set beresp.saintmode = 2h; 
		} 
    	#@todo: maybe we should strip cookies ?
		return(restart); 
	} 
	elsif (beresp.status >= 300 ) { 
	#http://stackoverflow.com/questions/12691489/varnish-hit-for-pass-means
	#hit for cache allow parallel execution in the backend instead of serial execution from varnish to the backend
		return(hit_for_pass);
	}

	## gestion des cookies (pages spécifiques).
	# on renvoit les cookies sur les pages d'authentification et de logout .
	# si autre page d'aut il faut la mettre ici ... pour le reste le visiteur a pas besoin de recevoir les cookies en retour ...il les a dans son client
	#@todo: attention poll
	#@todo: esi ...
    #@todo: d'apres mooi pas besoin renvoyer cookies pour dpicache_Esi_profile_info.php
    #if (req.url ~ "^/user"  || req.url ~ "^/logout"){
    if (req.url ~ "^/user"  || req.url ~ "^/logout" ||  req.url ~ "^/dpisso-loginmanager.php" ||  req.url ~ "^/dpicache_esi_profile_info.php"){
    # Ici, on laisse les cookies 
    } else {
    
    
		unset beresp.http.set-cookie;
    }
  
    return (deliver);
}

## --------------------------------------------------------------------
## 
## --------------------------------------------------------------------

include "default-conf/dpi7/cache_control/static_file_cache_control.vcl";

sub vcl_deliver {

    # On ajoute quelques infos pour le débug dans l'entete
    if (obj.hits > 0) {
		set resp.http.X-Cache = "HIT_" + server.hostname + " " + server.identity; 
		set resp.http.X-CacheHits = obj.hits ; 
		set resp.http.X-CacheTTL = req.http.X-CacheTtl ; 
		set resp.http.X-CacheLastUse = req.http.X-CacheLastUse ; 
	} else { 
		set resp.http.X-Cache = "MISS_" + server.hostname; 
	}


    # Retrait des lignes de l'entete http inutiles.
    remove resp.http.X-Varnish;
    remove resp.http.Via;
    remove resp.http.Server;
    remove resp.http.X-Drupal-Cache;
    remove resp.http.X-Generator;


	#todo set Etag to the TTL so a user will never do two hit on the same ressource
    if (req.url !~ "(?i)\.(png|gif|jpeg|jpg|ico|swf|css|js|html|htm|txt|zip|svg|xml)/?(\?.*)?$") {
		remove resp.http.ETag;
    }
    
    set resp.http.X-hash = req.http.X-CacheHash;



    return (deliver);
}







## --------------------------------------------------------------------
## custom error pages to replace Guru Meditation
## --------------------------------------------------------------------
#include "default-conf/dpi/errorpages/errorpage_200_inline.vcl";
#include "default-conf/dpi/errorpages/errorpage_403_inline.vcl";
#include "default-conf/dpi/errorpages/errorpage_503_inline.vcl";
#include "default-conf/dpi/errorpages/errorpage_404.vcl";

## default errorpage must come last in vcl_error()
#include "default-conf/dpi/errorpages/errorpage_default_inline.vcl";
## don't include errorpages/ beyond this point

sub vcl_error {
    set obj.http.Content-Type = "text/html; charset=utf-8";
    set obj.http.Retry-After = "5";
  synthetic {"
  <?xml version="1.0" encoding="utf-8"?>
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  <html>
    <head>
      <title>dpi7.BE - erreur "} + obj.status + " " + obj.response + {" </title>
      <style type='text/css'>
        body {
          color:#2A2A2A;
          background:none repeat scroll 0 0 #EDEDED;
          font: 0.75em/1.5em Verdana,"DejaVu Sans","Bitstream Vera Sans",Geneva,sans-serif;
          padding:30px 60px;
        }

        .main {
          background-color:#FFF;
          padding:60px;
        }

        h1 {
          color:#0065A3;
          margin-bottom:35px;
        }
      </style>

		<script type="text/javascript">
		  var _gaq = _gaq || [];
		  _gaq.push(['_setAccount', 'UA-47356246-1']);
		  _gaq.push(['_trackPageview',"\/503"]);
		  (function() {
			var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
			ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
			var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		  })();
		</script>
    </head>
    <body>
      <div class='main'>
        <h1>Erreur "} + obj.status + " " + obj.response + {"</h1>
        <p>Nous rencontrons actuellement des difficult&eacute;s techniques.</p>
        <p>Nous vous prions de nous excuser pour la g&ecirc;ne occasionn&eacute;e.</p>
        <p class='font-size:0.8em;'>XID: "} + req.xid + {"</p>
     </div>
    </body>
  </html>
  "};
  return (deliver);
}
