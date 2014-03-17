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
## backends
## --------------------------------------------------------------------

include "custom/vlan/config/backend_stage_RR.vcl";
## ACLs
include "custom/vlan/config/acl_httpsproxy.vcl";
#include "custom/vlan/config/acl_extcache.vcl";
#include "custom/vlan/config/acl_freshforce.vcl";
include "custom/vlan/config/acl_purge.vcl";

## --------------------------------------------------------------------
## helper functions
## --------------------------------------------------------------------

## remove cache-blocking headers from backend response
include "common/sub_remove_cacheblock_beresp.vcl";

## Restart on 503 - DO NOT USE with drupal ESI per ROLE/USER/...
include "common/error_restart.vcl";

## Detect device
#include "common/device_detect.vcl";

## --------------------------------------------------------------------
## common snippets (activate as needed)
## --------------------------------------------------------------------

## PURGE requests
## for ban lurker support, use purge_noreq instead of purge.vcl
#include "common/purge.vcl";
include "common/purge_noreq.vcl";

## reject /w00tw00t requests
include "common/no_w00t.vcl";

## force a cache miss if the client sets an "X-FreshForce: yes" header
#include "common/freshforce_header.vcl";

## force a cache miss if the client address matches the freshforce acl
#include "common/freshforce_clientip.vcl";

## force a cache miss if the user agent matches "Googlebot"
#include "common/freshforce_googlebot.vcl";

## add "Connection: close" to piped requests
include "common/pipe_close.vcl";

## return 302 or 301 redirect from VCL
include "common/redirect.vcl";

## restart the request on backend error
include "common/error_restart.vcl";

## repair weird request format "GET http://host/path"
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
#include "common/esi.vcl";

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

## Varnish-ping for loadbalancers
include "common/ping.vcl";

## X Forwarded For (proxy)
include "common/x_forwarded_for.vcl";

## --------------------------------------------------------------------
## custom code here
## --------------------------------------------------------------------
include "custom/vlan/proxy.vcl"; 

## Drupal Common : Forbidden Files
include "common/drupal/forbidden_url_d7.vcl";


## --------------------------------------------------------------------
## Below is a copy of the default VCL logic.
## The built-in logic will be appended to your code.
## --------------------------------------------------------------------

include "custom/vlan/forbidden_url.vcl";

sub vcl_recv {

   ## We only deal with GET and HEAD by default
   if (req.request != "GET" && req.request != "HEAD") {
		return (pass);
   }

   ## No cache for public editing pages
   if (req.url ~ "(?i)^/e/(.*)?$") {
		return (pass);
   }

   ## Force Refresh if referer is "/e/xxxx" (public edition.
   if (req.http.referer && req.http.referer ~ "(?i)/e/(.*)?$") {
		set req.hash_always_miss = true;
   }

   ## Gestion du temps de grace
   ## Temps pendant lequel on continue à servir le contenu
   ## en cache même s'il est périmé.
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

include "custom/vlan/normalize_hash.vcl";

sub vcl_hash {
    return (hash);
}

## --------------------------------------------------------------------
## 
## --------------------------------------------------------------------
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

    call remove_cacheblock_beresp;

	## TTL et temps de grace par defaut  
	set beresp.ttl = 15m;
	set beresp.grace = 30m;

	## Pour les fichiers, on augmente volontiers le temps de mise en cache
	if (req.url ~ "^/sites/default/files/" || req.url ~ "(?i)\.(png|gif|jpe?g|ico|txt|swf|css|js|pdf|zip|wav|avi|svg)/?(\?.*)?") {
		unset beresp.http.set-cookie;
		set beresp.ttl = 1h;
		set beresp.grace = 2h;
	}

	## On gere en fonction des status HTTP retournés
	if (beresp.status == 404) {
		unset beresp.http.set-cookie; 
		set beresp.ttl = 30m; 
		return(deliver);
	}
	elsif(beresp.status == 301){
		unset beresp.http.set-cookie; 
		set beresp.ttl = 1h;
		return(deliver);
	}
	elsif (beresp.status >= 500) { 
		if (req.url ~ "(?i)\.(png|gif|jpeg|jpg|ico|swf|css|js|pdf|zip|wav|avi)/?(\?.*)?$") { 
			set beresp.saintmode = 2h;
		} else { 
		  set beresp.saintmode = 15m; 
		} 
		return(restart); 
	} 
	elsif (beresp.status >= 300 ) { 
		return(hit_for_pass);
	}

	## gestion des cookies (pages spécifiques).
    if (req.url ~ "^/user"  || req.url ~ "^/logout"){
    # Ici, on laisse les cookies 
    } else {
		unset beresp.http.set-cookie;
    }
  
    return (deliver);
}

## --------------------------------------------------------------------
## 
## --------------------------------------------------------------------

include "custom/vlan/cache_control.vcl";

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
    set resp.http.X-hash = req.http.X-CacheHash;


    # Retrait des lignes de l'entete http inutiles.
    remove resp.http.X-Varnish;
    remove resp.http.Via;
    remove resp.http.Server;
    remove resp.http.X-Drupal-Cache;
    remove resp.http.X-Generator;

    if (req.url !~ "(?i)\.(png|gif|jpeg|jpg|ico|swf|css|js|html|htm|txt|zip|svg|xml)/?(\?.*)?$") {
		remove resp.http.ETag;
    }


    return (deliver);
}


## --------------------------------------------------------------------
## custom error pages to replace Guru Meditation
## --------------------------------------------------------------------
#include "custom/vlan/errorpages/errorpage_200_inline.vcl";
#include "custom/vlan/errorpages/errorpage_403_inline.vcl";
#include "custom/vlan/errorpages/errorpage_503_inline.vcl";
#include "custom/vlan/errorpages/errorpage_404.vcl";

## default errorpage must come last in vcl_error()
#include "custom/vlan/errorpages/errorpage_default_inline.vcl";
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
      <title>VLAN.BE - erreur "} + obj.status + " " + obj.response + {" </title>
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

sub vcl_init {
	return (ok);
}

sub vcl_fini {
	return (ok);
}
