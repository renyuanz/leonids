---
layout: post
title: Consuming WSDL Web Services with Perl or Python
date: 2013-02-21 20:40:04.000000000 +00:00
categories:
- Linux
---
If you ever try to talk from a script with Web Service that via WSDL definition, you may end up with a script like this:
{% highlight bash %}
#!/usr/bin/perl
use SOAP::Lite +trace => 'debug';
#use SOAP::Lite;
use Data::Dumper;
use strict;
use warnings;
my $serviceWsdl = 'http://server/service?wsdl';
my $soap = SOAP::Lite
  ->service($serviceWsdl);
my $result = $soap->serviceMethod();
unless ($result->fault) {
	print $result->result();
} else {
	print join ', ',
	      $result->faultcode,
	      $result->faultstring;
}
{% endhighlight %}
This will work with some web services, but with others it will not, especially when the method invoked on the service is parameter-less.
The resulted XML code will show xsi:nil="true" in the method invocation, what will effectively break the query.
To overcome this, I just switched to Python and came up with this simple script:
{% highlight bash %}
from suds.client import Client
client = Client('http://server/service?wsdl')
print client.service.serviceMethod()
{% endhighlight %}
