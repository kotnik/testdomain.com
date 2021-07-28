❯ docker run --rm -it -v $(pwd)/dnsconfig.js:/dns/dnsconfig.js -v $(pwd)/creds.json:/dns/creds.json -e AWS_ACCESS_KEY_ID="$AWS_ACCESSKEY_ID" -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" stackexchange/dnscontrol dnscontrol version
dnscontrol v3.11.0 ("6fc3534aa3b74bdb4b7fb7092068abc26e4753e1[dirty]") built 25 Jul 21 16:06 UTC

❯ docker run --rm -it -v $(pwd)/dnsconfig.js:/dns/dnsconfig.js -v $(pwd)/creds.json:/dns/creds.json -e AWS_ACCESS_KEY_ID="$AWS_ACCESSKEY_ID" -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" stackexchange/dnscontrol dnscontrol get-zone --format js  "r53" "ROUTE53" testdomain.com
var r53 = NewDnsProvider("r53", "ROUTE53");
var REG_CHANGEME = NewRegistrar("ThirdParty", "NONE");
D("testdomain.com", REG_CHANGEME,
        DnsProvider(r53),
        //NAMESERVER('ns-1294.awsdns-33.org.'),
        //NAMESERVER('ns-546.awsdns-04.net.'),
        //NAMESERVER('ns-2034.awsdns-62.co.uk.'),
        //NAMESERVER('ns-239.awsdns-29.com.')
)

❯ aws route53 change-resource-record-sets --hosted-zone-id Z01051993MXQIIBA5LIGH --change-batch file://dns-entries.json
{
    "ChangeInfo": {
        "Id": "/change/C01439381P3QHUM9IV55I",
        "Status": "PENDING",
        "SubmittedAt": "2021-07-28T13:52:08.312Z",
        "Comment": "CREATE/DELETE/UPSERT a record "
    }
}

❯ docker run --rm -it -v $(pwd)/dnsconfig.js:/dns/dnsconfig.js -v $(pwd)/creds.json:/dns/creds.json -e AWS_ACCESS_KEY_ID="$AWS_ACCESSKEY_ID" -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" stackexchange/dnscontrol dnscontrol get-zone --format js  "r53" "ROUTE53" testdomain.com
var r53 = NewDnsProvider("r53", "ROUTE53");
var REG_CHANGEME = NewRegistrar("ThirdParty", "NONE");
D("testdomain.com", REG_CHANGEME,
        DnsProvider(r53),
        //NAMESERVER('ns-1294.awsdns-33.org.'),
        //NAMESERVER('ns-546.awsdns-04.net.'),
        //NAMESERVER('ns-2034.awsdns-62.co.uk.'),
        //NAMESERVER('ns-239.awsdns-29.com.'),
        A('a', '4.4.4.4'),
        CNAME('cname-nodot', 'some-site.com'),
        NS('ns-nodot', 'some-other-site.com')
)

❯ docker run --rm -it -v $(pwd)/dnsconfig.js:/dns/dnsconfig.js -v $(pwd)/creds.json:/dns/creds.json -e AWS_ACCESS_KEY_ID="$AWS_ACCESSKEY_ID" -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" stackexchange/dnscontrol dnscontrol preview
2021/07/28 13:53:10 printIR.go:88: 2 Validation errors:
2021/07/28 13:53:10 printIR.go:94: ERROR: in CNAME cname-nodot.testdomain.com: target (some-site.com) must end with a (.) [https://stackexchange.github.io/dnscontrol/why-the-dot]
2021/07/28 13:53:10 printIR.go:94: ERROR: in NS ns-nodot.testdomain.com: target (some-other-site.com) must end with a (.) [https://stackexchange.github.io/dnscontrol/why-the-dot]
exiting due to validation errors

❯ docker run --rm -it -v $(pwd)/dnsconfig.js:/dns/dnsconfig.js -v $(pwd)/creds.json:/dns/creds.json -e AWS_ACCESS_KEY_ID="$AWS_ACCESSKEY_ID" -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" stackexchange/dnscontrol dnscontrol preview
******************** Domain: testdomain.com
----- Getting nameservers from: r53
----- DNS Provider: r53...
1 correction
#1:
MODIFY CNAME cname-nodot.testdomain.com: (some-site.com ttl=300) -> (some-site.com. ttl=300)
MODIFY NS ns-nodot.testdomain.com: (some-other-site.com ttl=300) -> (some-other-site.com. ttl=300)
MODIFY NS testdomain.com: (ns-239.awsdns-29.com. ttl=172800) -> (ns-239.awsdns-29.com. ttl=300)
MODIFY NS testdomain.com: (ns-2034.awsdns-62.co.uk. ttl=172800) -> (ns-2034.awsdns-62.co.uk. ttl=300)
MODIFY NS testdomain.com: (ns-546.awsdns-04.net. ttl=172800) -> (ns-546.awsdns-04.net. ttl=300)
MODIFY NS testdomain.com: (ns-1294.awsdns-33.org. ttl=172800) -> (ns-1294.awsdns-33.org. ttl=300)

----- Registrar: ThirdParty...
0 corrections
Done. 1 corrections.

❯ docker run --rm -it -v $(pwd)/dnsconfig.js:/dns/dnsconfig.js -v $(pwd)/creds.json:/dns/creds.json -e AWS_ACCESS_KEY_ID="$AWS_ACCESSKEY_ID" -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" stackexchange/dnscontrol dnscontrol push
******************** Domain: testdomain.com
----- Getting nameservers from: r53
----- DNS Provider: r53...
1 correction
#1:
MODIFY CNAME cname-nodot.testdomain.com: (some-site.com ttl=300) -> (some-site.com. ttl=300)
MODIFY NS ns-nodot.testdomain.com: (some-other-site.com ttl=300) -> (some-other-site.com. ttl=300)
MODIFY NS testdomain.com: (ns-239.awsdns-29.com. ttl=172800) -> (ns-239.awsdns-29.com. ttl=300)
MODIFY NS testdomain.com: (ns-2034.awsdns-62.co.uk. ttl=172800) -> (ns-2034.awsdns-62.co.uk. ttl=300)
MODIFY NS testdomain.com: (ns-546.awsdns-04.net. ttl=172800) -> (ns-546.awsdns-04.net. ttl=300)
MODIFY NS testdomain.com: (ns-1294.awsdns-33.org. ttl=172800) -> (ns-1294.awsdns-33.org. ttl=300)

SUCCESS!
----- Registrar: ThirdParty...
0 corrections
Done. 1 corrections.

❯ docker run --rm -it -v $(pwd)/dnsconfig.js:/dns/dnsconfig.js -v $(pwd)/creds.json:/dns/creds.json -e AWS_ACCESS_KEY_ID="$AWS_ACCESSKEY_ID" -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" stackexchange/dnscontrol dnscontrol push
******************** Domain: testdomain.com
----- Getting nameservers from: r53
----- DNS Provider: r53...
1 correction
#1:
MODIFY CNAME cname-nodot.testdomain.com: (some-site.com ttl=300) -> (some-site.com. ttl=300)
MODIFY NS ns-nodot.testdomain.com: (some-other-site.com ttl=300) -> (some-other-site.com. ttl=300)

SUCCESS!
----- Registrar: ThirdParty...
0 corrections
Done. 1 corrections.

❯ docker run --rm -it -v $(pwd)/dnsconfig.js:/dns/dnsconfig.js -v $(pwd)/creds.json:/dns/creds.json -e AWS_ACCESS_KEY_ID="$AWS_ACCESSKEY_ID" -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" stackexchange/dnscontrol dnscontrol push
******************** Domain: testdomain.com
----- Getting nameservers from: r53
----- DNS Provider: r53...
1 correction
#1:
MODIFY CNAME cname-nodot.testdomain.com: (some-site.com ttl=300) -> (some-site.com. ttl=300)

SUCCESS!
----- Registrar: ThirdParty...
0 corrections
Done. 1 corrections.

❯ docker run --rm -it -v $(pwd)/dnsconfig.js:/dns/dnsconfig.js -v $(pwd)/creds.json:/dns/creds.json -e AWS_ACCESS_KEY_ID="$AWS_ACCESSKEY_ID" -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" stackexchange/dnscontrol dnscontrol push
******************** Domain: testdomain.com
----- Getting nameservers from: r53
----- DNS Provider: r53...
0 corrections
----- Registrar: ThirdParty...
0 corrections
Done. 0 corrections.
