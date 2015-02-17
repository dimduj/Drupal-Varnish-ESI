## Probing action  to catch if the backend is sick ou healty
probe actsprobe
{
        .request =
         "GET /robots.txt HTTP/1.1"
         "Host: ena-dev.lesoir.be" # host transmis à un host apache lors requet probing pas le host interogé
         "Connection: close";
        .timeout = 0.8s;
        .interval = 5s;
        .window = 30;
        .threshold = 28;
}


backend dpiserver01
{
        .host = "ena-dev.lesoir.be";
        .port = "8083";
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
}


include "default-conf/dpi7.vcl";

