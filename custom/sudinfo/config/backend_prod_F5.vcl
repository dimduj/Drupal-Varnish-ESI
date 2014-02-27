# Backend Wally
#
backend vs_bwebsudp
{
        .host = "vs-bwebsudp.rossel.be";
        .port = "80";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 20s;
        .probe = {
                 .request =
                        "GET /PRESSFLOW.txt HTTP/1.1"
                        "Host: vs-bwebsudp.rossel.be"
                        "Connection: close";
				.timeout = 20s;  .interval = 15s;   .window = 5;
				.threshold = 3;
         }
}

# Backend Anciens serveurs SudPresse
#
backend legacysp {
		.host = "legacy.sudpresse.be";
		.port = "80";
		.first_byte_timeout = 120s;
		.between_bytes_timeout = 120s;
		.connect_timeout = 20s;
        .probe = {
                 .request =
                        "GET /ping.txt HTTP/1.1"
                        "Host: legacy.sudpresse.be"
                        "Connection: close";
				.timeout = 20s;  .interval = 15s;   .window = 5;
				.threshold = 3;
         }
}
