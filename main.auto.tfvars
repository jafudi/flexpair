tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaas3oie74wurpodkrygjpztwfscowu3rx42hadgheqrcmesnefllqa"
user_ocid = "ocid1.user.oc1..aaaaaaaaqfmvke4guehv3ejzc6p2nm4p7gki3o6csth2cqznv62zco76h6aa"
region = "eu-frankfurt-1" // Must equal home region of the tenancy
timezone = "Europe/Berlin"
locale = "de_DE.UTF-8"

gateway_shape = "VM.Standard.E2.1"
desktop_shape = "VM.Standard.E2.1"
# Processor: AMD EPYC 7551
# Base frequency: 2.0 GHz, max boost frequency: 3.0 GHz
# Memory: 8 GB
# Bandwidth: 700 Mbps
# Boot Volume Size: 50 GB

registered_domain = "jafudi.de" // Registered through internetwerk.de

/* TSIG (Transaction SIGnature) is a computer-networking protocol defined in RFCs 2136 and 2845.
Primarily it enables the Domain Name System (DNS) to authenticate updates to a DNS database.
It is most commonly used to update Dynamic DNS or a secondary/slave DNS server.
TSIG uses shared secret keys and one-way hashing to provide a cryptographically secure means
of authenticating each endpoint of a connection as being allowed to make or respond to a DNS update.
Source: Wikipedia */

rfc2136_name_server = "ns1.dynv6.com" // Offers full implementation of RFC2136 and TSIG for free
rfc2136_key_name = "tsig-164066.dynv6.com."
rfc2136_tsig_algorithm = "hmac-sha512" // Support for hmac-sha224, hmac-sha256, hmac-sha384, hmac-sha512
rfc2136_key_secret = "7I57AtxCp7PHfAfWsV9TviS+B3glddd9PGoBMo1bYBSicoKM3BdaQL9qnZBX7uy6Vi8r+46/HmOrMq767RRTPA=="

murmur_port = "64738" // Standard is port 64738

mailbox_prefix = "mail"

gitlab_runner_token = "JW6YYWLG4mTsr_-mSaz8"