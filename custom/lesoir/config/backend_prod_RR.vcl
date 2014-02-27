# Backend Wally
#
probe wally_test
{
	.request =
     "GET /varnish_test.php HTTP/1.1"
     "Host: www.lesoir.be"
     "Connection: close";
	.timeout = 0.8s;
	.interval = 5s;
	.window = 30;
	.threshold = 28;
}
backend bapaselp02
{
        .host = "bapaselp02.rossel.be";
        .port = "80";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
        .probe = wally_test;
}

backend bapaselp03
{
        .host = "bapaselp03.rossel.be";
        .port = "80";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
        .probe = wally_test;
}

backend bapaselp04
{
        .host = "bapaselp04.rossel.be";
        .port = "80";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
        .probe = wally_test;
}

backend bapaselp05
{
        .host = "bapaselp05.rossel.be";
        .port = "80";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
        .probe = wally_test;
}

backend bapaselp06
{
        .host = "bapaselp06.rossel.be";
        .port = "80";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
        .probe = wally_test;
}


backend bapaselp07
{
        .host = "bapaselp07.rossel.be";
        .port = "80";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
        .probe = wally_test;
}

backend bapaselp08
{
        .host = "bapaselp08.rossel.be";
        .port = "80";
        .saintmode_threshold = 0;
        .first_byte_timeout = 120s;
        .between_bytes_timeout = 120s;
        .connect_timeout = 1s;
        .probe = wally_test;
}



director vs_bapaselp round-robin {
        {
                .backend = bapaselp02;
        }
        {
                .backend = bapaselp03;
        }
        {
                .backend = bapaselp04;
        }
        {
                .backend = bapaselp05;
        }
        {
                .backend = bapaselp06;
        }
        {
                .backend = bapaselp07;
        }
        {
                .backend = bapaselp08;
        }
}

# Backend Anciens serveurs LESOIR
#
backend legacylesoir {
		.host = "legacy.lesoir.be";
		.port = "80";
		.first_byte_timeout = 120s;
		.between_bytes_timeout = 120s;
		.connect_timeout = 1s;
        .probe = {
                 .request =
                        "GET /ping.txt HTTP/1.1"
                        "Host: legacy.lesoir.be"
                        "Connection: close";
		.timeout = 0.5s;  
		.interval = 5s;   
		.window = 20;
		.threshold = 18;
         }
}

