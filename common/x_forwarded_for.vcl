sub vcl_recv {

    if (req.restarts == 0) {
  	  if (req.http.x-forwarded-for) {
	    set req.http.X-Forwarded-For =
		req.http.X-Forwarded-For + ", " + client.ip;
	  } else {
	    set req.http.X-Forwarded-For = client.ip;
	  }
    }

}
