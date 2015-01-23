#@todo: use ESI+GZIP => https://www.varnish-cache.org/docs/trunk/phk/gzip.html



backend loginmanager
{
        .host = "login-manager-stage.rossel.be";
        .port = "80";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
      #  .probe = actsprobe;
}


backend accessmanager
{
        #.host = "login-manager-stage.rossel.be";
        .host = "access-manager-stage.rossel.be";
        .port = "80";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
      #  .probe = actsprobe;
}













## When starting a new request check if we need to hook through role system ##
sub vcl_recv {

 //@todo: We should ensure that the user has a valid session or logout him otherwise it could lost hil in a no man's land
 //get dpissoLoginToken value & know if user is connected
 set req.http.X-dpisso_loginToken=regsub( req.http.Cookie, "^.*?dpisso_loginToken=([^;]*);*.*$","\1" );
 set req.http.X-dpisso-is_connected=regsub( req.http.Cookie, "^.*?dpisso_is_connected=([^;]*);*.*$","\1" );



  //First we need to get the loginId for the loginToken. If we are not loggedin we need to login first...
  if(  req.restarts==0  && req.http.X-dpisso-is_connected!="1" && !req.http.X-dpisso-loginToken){

  //@todo: redirect to Drupal login page
  }else if(  req.restarts==0  && req.http.X-dpisso-is_connected=="1" && !req.http.X-dpisso-loginToken){
     //buildUrlForLM
       set req.http.X-Original-URL = req.url;
       set req.url="/services/getLoginId?loginToken="+regsub( req.http.Cookie, "^.*?dpisso_loginToken=([^;]*);*.*$","\1" );
       set req.backend = loginmanager;

       return (lookup);

  }


  if(  req.restarts>0 && !req.http.AM-is-freemium ){
    set req.http.X-dpisso_unitId=regsub( req.http.Cookie, "^.*?dpisso_unitId=([^;]*);*.*$","\1" );
    set req.http.X-dpisso_cookieId=regsub( req.http.Cookie, "^.*?monsitedpi7=([^;]*);*.*$","\1" );

    set req.http.X-Original-URL = req.url;
    set req.url="/services/getLoginId?loginToken="+regsub( req.http.Cookie, "^.*?dpisso_loginToken=([^;]*);*.*$","\1" );
    set req.backend = accessmanager;

    set req.url="/dpiSSO_AM_getServicesForLoginId?unitId="+req.http.X-dpisso_unitId+"&cookieId="+req.http.X-dpisso_cookieId+"&url="+req.http.X-Original-URL+"&loginId="+req.http.X-dpisso_loginId;


    if(req.url !~ "/esi/"){
      return(pass);
    }
    else{
      return (lookup);
    }
  }




}

sub vcl_hash {

//@todo: define TTL
if (req.backend == loginmanager) {
    hash_data(req.http.X-dpisso_loginToken);
    return(hash);
  }


//@todo: define TTL
elseif (req.backend == accessmanager) {
    hash_data(req.http.X-dpisso_loginId);
    return(hash);
  }
  else{

      hash_data("freemium:"+req.http.AM-is-freemium);
      return(hash);


  }
}


sub vcl_deliver {

    if (req.backend == loginmanager) {
               set req.url = req.http.X-Original-URL;
               unset req.http.X-Original-URL;

               set req.http.X-dpisso_loginId=resp.http.Lm-Loginid;
               set req.backend = dpiserver01;
               return (restart);
    }

    if (req.backend == accessmanager) {
                     set req.url = req.http.X-Original-URL;
                     unset req.http.X-Original-URL;

                     set req.http.X-dpisso_loginId=resp.http.Lm-Loginid;
                     set req.backend = dpiserver01;

                     set req.http.AM-is-freemium=resp.http.AM-is-freemium;
                     return (restart);
    }





}