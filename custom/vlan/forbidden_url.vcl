sub vcl_recv {

  if (req.url ~ "(?i)^/(user)/?.*$"
  ) {
    error 404 "Page not found.";
  }

}
