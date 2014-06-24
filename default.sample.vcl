## Probing action  to catch if the backend is sick ou healty
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

/*
## Round robin mechanism with multiple varnish server

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


## each host can be evicted from the round robbing if it doesnt' respond to the actsprobe
director default round-robin {
        {
                .backend = dpiserver01;
        }
        {
                .backend = dpiserver02;
        }
}

## Here we can define another backend for legacy (old server)
## @see: default-conf/dpi7/proxy/proxy.vcl 

backend portallegacy {
        .host = "portal.vlan.be";
        .port = "80";
        .max_connections = 200;
}

*/




include "default-conf/dpi7.vcl";

