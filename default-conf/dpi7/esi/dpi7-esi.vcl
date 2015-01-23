#@todo: use ESI+GZIP => https://www.varnish-cache.org/docs/trunk/phk/gzip.html


## When starting a new request check if we need to hook through role system ##
sub vcl_recv {

  # Security sanity check
  # Check that the esi_get_user_infos is not asked by end-user as it's a pure internal call
  if (req.url == "/dpicache_esi_profile_info.php" && req.restarts == 0) {
    error 401 "Direct call to user info is denied"; 
  }
  if(req.restarts == 0 && (req.http.X-Dpicache-roles || req.http.X-Dpicache-userid || req.http.X-Dpicache-username)){
    error 503 "You try to force the X-dpicache-role, X-Dpicache-userid or X-Dpicache-username. remove it from your header :)";
  }
  if(req.restarts==0 && (req.url ~ "^esi/.*/\?dpicache-roles=*$" || req.url ~ "^esi/.*/\?dpicache-usernames=*$")){
  
  }
  

  
  # End Security Check



  # The URL structure of ESI blocks identifies which are per-user or per-role.
  # e.g. /esi/block/garland:left:foo:bar/node%2F1/CACHE%3DUSER
  # Add a header to show if we're using a particular cache strategy.
  if ((req.url ~ "^/esi/block" ) || (req.url ~ "^/esi/panels_pane") || (req.url ~ "^/esi/dpicache" )) {
    if(req.restarts==0){
      set req.http.X-Dpicache-use_esi=1;
      
      #### Unset every expected headers ####
      unset req.http.X-Dpicache-roles;
      unset req.http.X-Dpicache-username;

      # Pass for NOCACHE
      if ( req.url ~ "^.*/CACHE%3DNOCACHE[^/]*$" ) {
        # Strip the cache-instruction from the end of the URL for the ease of url construction on ban.
        set req.url = regsub( req.url, "^(.*)/CACHE%3D[^/]*$", "\1" );
        return (pass);
      }
    
      # look for a cache instruction. This should be the final argument to the URL
      # and should have the value 'USER' or 'ROLE'.
      # We check for role datas
      set req.http.X-Dpicache-flute="coco";

      if ( req.url ~ "^.*/CACHE%3D[^/]*$" ) {
        set req.http.X-Dpicache-graffffy="ggg";
        # Set an HTTP_X-Dpicache-granularity header to be appropriate setting.
        set req.http.X-Dpicache-granularity = regsub( req.url, "^.*/CACHE%3D([^/]*)$", "\1" );

        # Strip the cache-instruction from the end of the URL.
        set req.url = regsub( req.url, "^(.*)/CACHE%3D[^/]*$", "\1" );
        ## We'll always restart once. Therefore, when restarts == 0 we can ensure
        ## that the HTTP headers haven't been tampered with by the client.
      
        // We're going to change the URL to dpicache_esi_profile_info.php so we'll need to save
        // the original one first.
        ### Save the original URL ###
        set req.http.X-Original-URL = req.url; 
        set req.url = "/dpicache_esi_profile_info.php";
        ### Send Everything to vcl_hash ###
        return (lookup); 
     
      }
    }
    else{

      if ( req.http.X-Dpicache-granularity == "USER" ) {

        set req.url = req.url+"?dpicache-username="+req.http.X-Dpicache-username;
        set req.http.X-Original-URL = req.url;
        //error 503 req.url;
      }
      elsif (req.http.X-Dpicache-granularity == "ROLE"){
        set req.url = req.url+"?dpicache-roles="+req.http.X-Dpicache-roles+"&page=1";
        set req.http.X-Original-URL = req.url;
      }
      
    } 
  }

  # Ignore presence of cookies, etc, for ESI requests:
  # Always try to lookup ESIs from the cache.
  if(req.url ~ "^/esi.*") {
    return (lookup);
  }
}



# Create the hash for the user_info
sub vcl_hash {
  if (req.url ~"^/dpicache_esi_profile_info.php") {
    # Default hash
    hash_data(req.url);
    hash_data(req.http.host);
    # Per User / Session
    if( req.http.Cookie ~ "SESS" ) {
      # Adds the Sessid / sessvalue
      hash_data(regsub( req.http.Cookie, "^.*?SESS(.{32})=([^;]*);*.*$", "\1:\2" ));
    }
    if( req.http.Cookie ~ "USESS" ) {
      # Adds the Sessid / sessvalue
      hash_data(regsub( req.http.Cookie, "^.*?USESS(.{32})=([^;]*);*.*$", "U:\1:\2" ));
    }
    if( req.http.Cookie ~ "RSESS" ) {
      # Adds the Sessid / sessvalue
      hash_data(regsub( req.http.Cookie, "^.*?RSESS(.{32})=([^;]*);*.*$", "R:\1:\2" ));
    }
    return(hash);
  }

  # Customise the hash if required.
  else if ( req.http.X-Dpicache-use_esi ) {
    ## Hash the cache mode
    
    #if username = role name => we ensure unicity of the hash
    hash_data(req.http.X-Dpicache-granularity);
    //hash_data(req.url );
    
    
    
    
  }
  
}

### Fetch Part ###
sub vcl_fetch {

    set beresp.do_esi = true;


  # Set The user info ttl to 30 s
  if (req.url ~"^/dpicache_esi_profile_info.php") {
    set beresp.ttl = 30s;
    return (deliver);
  }
  #REMOVE THAT AND ASK WHY ...
  # ESI blocks with per-user or per-role config have a cache-control: private
  # header.  This removes the header and inserts the block into the cache.
  #if (beresp.http.X-Dpicache-roles && req.http.X-Dpicache-roles != beresp.http.X-Dpicache-roles) {
  #  set beresp.ttl = 0s;
  #  return (hit_for_pass);
  #}
  elseif (req.url ~ "^/esi.*"){
    //@todo: check si il faut les lgines en dessous
    return (deliver);
    
    if( req.http.X-Dpicache-granularity && beresp.http.Cache-Control ~ "private" ) {
   // unset beresp.http.Set-Cookie;
    unset beresp.http.Cache-Control;
    return (deliver);
  }
    
    }
  
  
}

### When returning get_user_infos, fallback to the original query ###
sub vcl_deliver {
  if (req.url == "/dpicache_esi_profile_info.php" && req.restarts == 0) {
     set req.http.X-Dpicache-roles = resp.http.X-Dpicache-roles;
     set req.http.X-Dpicache-username  = resp.http.X-Dpicache-username;
     set req.url = req.http.X-Original-URL;
     unset req.http.X-Original-URL;
     return (restart);
  }
  set resp.http.X-Dpicache-username  = req.http.X-Dpicache-username;
  set resp.http.X-Dpicache-granularity  = req.http.X-Dpicache-granularity;
  set resp.http.X-COCO  = "rrr";
  set resp.http.X-COCO3  = "rrr";
  set resp.http.X-Dpicache-graffffy=req.http.X-Dpicache-graffffy;
  set resp.http.X-Dpicache-flute=req.http.X-Dpicache-flute;


  
}