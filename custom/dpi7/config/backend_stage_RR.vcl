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

backend bapaacts01
{
        .host = "bapaacts01.rossel.be";
        .port = "8083";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
        .probe = actsprobe;
}

backend bapaacts02
{
        .host = "bapaacts02.rossel.be";
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

