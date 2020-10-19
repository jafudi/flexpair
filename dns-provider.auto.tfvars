# https://letsencrypt.org/docs/rate-limits/
# 50 certificates per registered domain per week
registered_domain = "jafudi.de" // Registered through internetwerk.de

/* TSIG (Transaction SIGnature) is a computer-networking protocol defined in RFCs 2136 and 2845.
Primarily it enables the Domain Name System (DNS) to authenticate updates to a DNS database.
It is most commonly used to update Dynamic DNS or a secondary/slave DNS server.
TSIG uses shared secret keys and one-way hashing to provide a cryptographically secure means
of authenticating each endpoint of a connection as being allowed to make or respond to a DNS update.
Source: Wikipedia */

rfc2136_name_server    = "ns1.dynv6.com" // Offers full implementation of RFC2136 and TSIG for free
rfc2136_key_name       = "tsig-164066.dynv6.com."
rfc2136_tsig_algorithm = "hmac-sha512" // Support for hmac-sha224, hmac-sha256, hmac-sha384, hmac-sha512
rfc2136_key_secret     = "7I57AtxCp7PHfAfWsV9TviS+B3glddd9PGoBMo1bYBSicoKM3BdaQL9qnZBX7uy6Vi8r+46/HmOrMq767RRTPA=="
