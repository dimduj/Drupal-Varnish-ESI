## Allow only a subset of HTTP Requests, disallow any other
sub vcl_recv {

    if (req.http.Authorization) {
        return (pass);
    }

	if (req.request !="GET" &&
		req.request !="HEAD" &&
		req.request !="POST") {
		error 405 "Not sure why you used this method but it's not allowed";
	}

}
