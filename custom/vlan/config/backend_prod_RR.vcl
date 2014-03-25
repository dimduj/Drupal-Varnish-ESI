probe actsprobe
{
        .request =
         "GET /robots.txt HTTP/1.1"
         "Host: www.vlan.be"
         "Connection: close";
        .timeout = 0.8s;
        .interval = 5s;
        .window = 30;
        .threshold = 28;
}

backend bapaactp01
{
        .host = "bapaactp01.rossel.be";
        .port = "8083";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
        .probe = actsprobe;
}

backend bapaactp02
{
        .host = "bapaactp02.rossel.be";
        .port = "8083";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
        .probe = actsprobe;
}

director default round-robin {
        {
                .backend = bapaactp01;
        }
        {
                .backend = bapaactp02;
        }
}

backend portalvlan {
        .host = "portal.vlan.be";
        .port = "80";
        .max_connections = 200;
}

