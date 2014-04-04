sub vcl_recv {

  if (req.url ~ "(?i)^/(user|api|ad)/?.*$") &&
     ( !req.url ~ "(?i)^/ad/print/?.*$") {
    error 404 "Page not found.";
  }

}
