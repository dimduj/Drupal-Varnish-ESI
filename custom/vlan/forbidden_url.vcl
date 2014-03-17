sub vcl_recv {

  if (req.url ~ "(?i)^/(user|api|ad)/?.*$"
  ) {
    error 404 "Page not found.";
  }

}
