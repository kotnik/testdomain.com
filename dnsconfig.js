var r53 = NewDnsProvider("r53", "ROUTE53");
var REG_CHANGEME = NewRegistrar("ThirdParty", "NONE");
D("testdomain.com", REG_CHANGEME,
        DnsProvider(r53),
        //NAMESERVER('ns-1294.awsdns-33.org.'),
        //NAMESERVER('ns-546.awsdns-04.net.'),
        //NAMESERVER('ns-2034.awsdns-62.co.uk.'),
        //NAMESERVER('ns-239.awsdns-29.com.'),
        A('a', '4.4.4.4'),
        CNAME('cname-nodot', 'some-site.com.'),
        NS('ns-nodot', 'some-other-site.com.')
)
