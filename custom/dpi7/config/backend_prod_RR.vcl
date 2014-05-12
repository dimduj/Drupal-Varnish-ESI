#Action de probing pour determiner si le backkend est sick ou healty
probe actsprobe
{
        .request =
         "GET /robots.txt HTTP/1.1"
         "Host: dpi7-dev.drupal.dev" # host transmis à un host apache lors requet probing pas le host interogé
         "Connection: close";
        .timeout = 0.8s;
        .interval = 5s;
        .window = 30;
        .threshold = 28;
}

backend dpiserver01
{
        .host = "dpi7-dev.drupal.dev";
        .port = "80";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
        .probe = actsprobe;
}

backend dpiserver02
{
        .host = "dpi7-dev.drupal.dev";
        .port = "80";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
        .probe = actsprobe;
}


# chacun des host server va être evincé du round robing si il ne remplis pas le probe actsprobe

director default round-robin {
        {
                .backend = dpiserver01;
        }
        {
                .backend = dpiserver02;
        }
}
# autre backend pour du legacy
#backend portallegacy {
#        .host = "portal.vlan.be";
#        .port = "80";
#        .max_connections = 200;
#}

