---
layout: post
title: Postfix SASL and LDAP Authorization
date: 2010-01-31 16:28:11.000000000 +00:00
categories:
- Linux
tags:
- postfix
- tls
- smtp
---
Hints for Postfix 2.6 or higher that are commonly mentioned problems or scenarios.

Enforcing From: header to match SASL login username
There are many situations where we have to make sure that the user that is trying to send e-mail is the rightful person. In practice, this means that a user that is logging in via username via SASL mechanism has to own the e-mail address that she is trying to send as.
To accomplish that, firstly we want to put an additional header to the mails being sent. This is done by putting into main.cf:
{% highlight bash %}
smtpd_sasl_authenticated_header=yes
{% endhighlight %}
This results in an additional header in mails, that are sent by SASL authenticated users:
{% highlight bash %}
(Authenticated sender: sasl_username)
{% endhighlight %}
Note: this is NOT required and this is potentially exposing your existing usernames to the world, making them easier to bruteforce or to spam. In this scenario however, this is anyway meaningless because from address == SASL username.
Next, we want to make sure that if the user is trying to send mail as name.surname@domain.com, then he has to be authenticated as name.surname via SASL. For that, we have to put:
{% highlight bash %}
smtpd_sender_restrictions = reject_sender_login_mismatch
smtpd_sender_login_maps = ldap:/etc/postfix/login-maps.cf&lt;
{% endhighlight %}
In my case, I am authorising the SASL users against LDAP directory, thus the login-maps.cf contains:
{% highlight bash %}
version = 3
server_host = localhost
search_base = dc=domain,dc=com
bind = yes
bind_dn = cn=user,dc=domain,dc=com
bind_pw = password
query_filter = (&amp;amp;(uid=%u)(objectClass=inetOrgPerson))
result_attribute = uid
{% endhighlight %}
What this map does, is it looks up in LDAP directory the SASL username (uid=%u) looking in objects of class InetOrgPerson.
For success, the lookup must return:
{% highlight bash %}
username           name.surname@domain.com
{% endhighlight %}
where name.surname@domain.com is the email that the user is trying to send as (from From: header).
