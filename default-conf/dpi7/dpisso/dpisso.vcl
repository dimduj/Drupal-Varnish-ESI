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
	if (req.url !~ "^[^?]*\.(png|jpg|gif|css|js|swf|flv|ico|xml|txt|pdf|doc|woff|eot|mp[34])(\?.*)?$") {
		if(req.url~"/dpisso-loginmanager.php"){
			std.syslog(0,"operation login / logout");
			//dont cash login and logout
			return(pipe);
		}
		else if(req.http.Cookie!~"monsitedpi7" || req.http.Cookie!~"dpisso_unitId"){
			//if unitId cookie or application cookie does not exist => call dpisso-loginmanager 
  			set req.http.X-Original-URL = req.url;
			set req.url = "/dpisso-loginmanager.php?operation=getApplicationToken&returnPage="+req.http.X-Original-URL;
			return(pipe);
		}
		else{
			set req.http.X-dpisso-unitId=regsub( req.http.Cookie, "^.*?dpisso_unitId=([^;]*);*.*$","\1" );
			set req.http.X-dpisso_cookieId=regsub( req.http.Cookie, "^.*?monsitedpi7=([^;]*);*.*$","\1" );
		}
		 //@todo: We should ensure that the user has a valid session or logout him otherwise it could lost hil in a no man's land
		 //get dpissoLoginToken value & know if user is connected
		 if(req.http.Cookie~"dpisso_loginToken"){
		 		 set req.http.X-dpisso_loginToken=regsub( req.http.Cookie, "^.*?dpisso_loginToken=([^;]*);*.*$","\1" );
		 }
		 if(req.http.Cookie~"dpisso_is_connected"){
			set req.http.X-dpisso-is_connected=regsub( req.http.Cookie, "^.*?dpisso_is_connected=([^;]*);*.*$","\1" );
		 }
	

		std.syslog(0,"=============================================");
		std.syslog(0,"restart: "+req.restarts);
		std.syslog(0,"requrl: "+req.url);
		std.syslog(0,"http Cookie recv:"+req.http.Cookie);
		
		std.syslog(0,"req.http.X-dpisso-is_connected"+req.http.X-dpisso-is_connected);
		std.syslog(0,"req.http.X-dpisso_loginToken"+req.http.X-dpisso_loginToken);
		
		  //First we need to get the loginId for the loginToken. If we are not loggedin we need to login first...
		 if(  req.restarts==0  && req.http.X-dpisso-is_connected!="1" && req.http.X-dpisso_loginToken){
  			set req.http.X-Original-URL = req.url;
			set req.url = "/dpisso-loginmanager.php?operation=connect?loginToken="+req.http.X-dpisso_loginToken+"&returnPage="+req.http.X-Original-URL;
			std.syslog(0,"login into Drupal => call to "+req.url);
			return(pipe);
			
		  }else if(  req.restarts==0  && req.http.X-dpisso-is_connected=="1" && req.http.X-dpisso_loginToken){
			 std.syslog(0,"session drupal ok => getloginId for logintoken");
			   set req.http.X-Original-URL = req.url;
			   set req.url="/services/getLoginId?loginToken="+regsub( req.http.Cookie, "^.*?dpisso_loginToken=([^;]*);*.*$","\1" );
			   std.syslog(0,"LM requrl"+req.url);

			   set req.backend = loginmanager;
			   return (lookup);

		  }
		  else if(!req.http.AM-is-freemium ){
			std.syslog(0,"getAM");
			set req.http.X-dpisso_unitId=regsub( req.http.Cookie, "^.*?dpisso_unitId=([^;]*);*.*$","\1" );
			set req.http.X-dpisso_cookieId=regsub( req.http.Cookie, "^.*?monsitedpi7=([^;]*);*.*$","\1" );
			set req.http.X-Original-URL = req.url;
			set req.backend = accessmanager;

			//@TOODO remove hardcode of unitID
			if(req.http.X-dpisso_loginId){
				set req.url="/dpiSSO_AM_getServicesForLoginId?unitId="+req.http.X-dpisso-unitId+"&cookieId="+req.http.X-dpisso_cookieId+"&url="+req.http.X-Original-URL+"&loginId="+req.http.X-dpisso_loginId;
			}
			else{
				set req.url="/dpiSSO_AM_getServicesForLoginId?unitId="+req.http.X-dpisso-unitId+"&cookieId="+req.http.X-dpisso_cookieId+"&url="+req.http.X-Original-URL;
			}
			std.syslog(0,"AM requrl"+req.url);
			if(req.url !~ "/esi/"){
					return(pass);
				}
			else{
				return (lookup);
			}   
		}	
	}
}

sub vcl_hash {
	if (req.url !~ "^[^?]*\.(png|jpg|gif|css|js|swf|flv|ico|xml|txt|pdf|doc|woff|eot|mp[34])(\?.*)?$") {
		//add req.url in hash
		std.syslog(0,"hash req.url: "+ req.url);
		hash_data(req.url);
		//@todo: define TTL
		if (req.backend == loginmanager) {
			std.syslog(0,"hash backend loginmanager"+req.http.X-dpisso_loginToken);
			hash_data(req.http.X-dpisso_loginToken);
			return(hash);
		  }


		//@todo: define TTL
		elseif (req.backend == accessmanager) {
			std.syslog(0,"hash backend AM"+req.http.X-dpisso_loginId);
			if(req.http.X-dpisso_loginId){
				hash_data(req.http.X-dpisso_loginId);
			}
			else{
				hash_data(req.http.X-dpisso_cookieId);
			}
		  }
		  else{
			std.syslog(0,"has normal => freemium:"+req.http.AM-is-freemium);
			  hash_data("freemium:"+req.http.AM-is-freemium);
			  return(hash);
		  }
	}
}



sub vcl_deliver {
	if (req.url !~ "^[^?]*\.(png|jpg|gif|css|js|swf|flv|ico|xml|txt|pdf|doc|woff|eot|mp[34])(\?.*)?$") {
	
		if (req.backend == loginmanager) {
				   set req.url = req.http.X-Original-URL;
				   unset req.http.X-Original-URL;
				   set req.http.X-dpisso_loginId=resp.http.Lm-Loginid;
				   set req.backend = dpiserver01;
				   std.syslog(0,"loginManagerDeliver: "+req.http.X-dpisso_loginId);
				   return (restart);
		}

		else if (req.backend == accessmanager) {
						 set req.url = req.http.X-Original-URL;
						 unset req.http.X-Original-URL;
						 set req.backend = dpiserver01;
						 set req.http.AM-is-freemium=resp.http.AM-is-freemium;
						 std.syslog(0,"accessManagerDeliver: "+req.http.AM-is-freemium);
						 return (restart);
		}
		
		//else if(req.url ~ "/dpisso-loginmanager.php\?operation=getApplicationToken"){
			//std.syslog(0,"dpisso deliver");
			//set req.url = req.http.X-Original-URL;
			//unset req.http.X-Original-URL;
			//std.syslog(0,"cookie in deliver: "+req.http.Cookie);
			//return(deliver);
		//}
		else{
			std.syslog(0,"normal deliver:"+req.url);
			std.syslog(0,"header AM:"+req.http.AM-is-freemium);
			return(deliver);
		}
	}
} 
