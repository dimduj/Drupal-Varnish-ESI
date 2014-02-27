# Backend Wally
#
backend vs_bapaselp
{
        .host = "vs-bapaselp.rossel.be";
        .port = "80";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 20s;
        .probe = {
                .request =
                        "GET /PRESSFLOW.txt HTTP/1.1"
                        "Host: vs-bapaselp.rossel.be"
                        "Connection: close";
				.timeout = 20s;  .interval = 15s;   .window = 5;
				.threshold = 3;
         }
}

# Backend Anciens serveurs LESOIR
#
backend legacylesoir {
		.host = "legacy.lesoir.be";
		.port = "80";
		.first_byte_timeout = 120s;
		.between_bytes_timeout = 120s;
		.connect_timeout = 20s;
        .probe = {
                 .request =
                        "GET /ping.txt HTTP/1.1"
                        "Host: legacy.lesoir.be"
                        "Connection: close";
				.timeout = 20s;  .interval = 15s;   .window = 5;
				.threshold = 3;
         }
}

