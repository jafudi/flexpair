# https://letsencrypt.org/docs/rate-limits/ => 50 certificates per registered domain per week
registered_domain = "jafudi.de" // Registered through internetwerk.de

rfc2136_name_server    = "ns1.dynv6.com" // Offers full implementation of RFC2136 and TSIG for free
rfc2136_key_name       = "tsig-164066.dynv6.com."
rfc2136_tsig_algorithm = "hmac-sha512" // Support for hmac-sha224, hmac-sha256, hmac-sha384, hmac-sha512
rfc2136_key_secret     = "7I57AtxCp7PHfAfWsV9TviS+B3glddd9PGoBMo1bYBSicoKM3BdaQL9qnZBX7uy6Vi8r+46/HmOrMq767RRTPA=="

timezone = "Europe/Berlin"
locale   = "de_DE.UTF-8"

gateway_shape = "VM.Standard.E2.1.Micro"
desktop_shape = "VM.Standard.E2.1.Micro"

gateway_username = "ubuntu"
desktop_username = "ubuntu"
