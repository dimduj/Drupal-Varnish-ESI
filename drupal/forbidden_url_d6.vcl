sub vcl_recv {

  if (req.url ~ "(?i)^/(install|update|cron|supercron)\.php(\?.*)?$"
    || req.url ~ "(?i)^/(supercron\/run-autocron-.*).*$"
    || req.url ~ "(?i)^/(admin|node\/add|devel.*).*$"
    || req.url ~ "(?i)^/?(.*)(\/changelog|\/readme)\.txt/?(\?.*)?$"
    || req.url ~ "(?i)^/?(.*)(\/changelog|\/readme)\.txt/?(\?.*)?$"
    || req.url ~ "^/sites/default/settings.php"
  ) {
    error 404 "Page not found.";
  }

}
