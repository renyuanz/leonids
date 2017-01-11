---
layout: post
title: No Debian Wheezy 7.0 XenServer template? Don't worry!
date: 2014-12-05 16:04:50.000000000 +00:00
categories:
- Linux
tags: []
---
There is no template for Debian Wheezy while creating new VMs in XenServer.
However, it is easy to clone it from the 6.0 version. Firstly we clone the template, then we change the parameters to use Wheezy.
{% highlight bash %}
# xe vm-clone uuid=`xe template-list name-label="Debian Squeeze 6.0 (64-bit)" --minimal` new-name-label="Debian Wheezy 7.0 (64-bit)"
# xe template-param-set other-config:default_template=true other-config:debian-release=wheezy uuid=`xe template-list name-label="Debian Wheezy 7.0 (64-bit)" --minimal`
{% endhighlight %}
