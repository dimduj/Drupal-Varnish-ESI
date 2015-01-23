probe actsprobe
{
        .request =
         "GET /robots.txt HTTP/1.1"
         "Host: site1-stage.dpi247.dev"
         "Connection: close";
        .timeout = 0.8s;
        .interval = 5s;
        .window = 30;
        .threshold = 28;
}

backend bapaacts01
{
        .host = "site1-stage.dpi247.dev";
        .port = "8083";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
        .probe = actsprobe;
}

backend bapaacts02
{
        .host = "site2-stage.dpi247.dev";
        .port = "8083";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
        .probe = actsprobe;
}

director default round-robin {
        {
                .backend = bapaacts01;
        }
        {
                .backend = bapaacts02;
        }
}

backend portalvlan {
        .host = "portal.vlan.be";
        .port = "80";
        .max_connections = 200;
}

