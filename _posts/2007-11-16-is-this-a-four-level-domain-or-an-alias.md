---
layout: post
title: Is this a four level domain or an alias?
date: 2007-11-16 03:51:20.000000000 +00:00
categories:
- Other
tags:
- dns domain network
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  _sexybookmarks_shortUrl: http://b2l.me/anjd9k
  _sexybookmarks_permaHash: a705c8986495175216670c335b90f361
author:
  login: radek.antoniuk@gmail.com
  email: radek.antoniuk@gmail.com
  display_name: warden
  first_name: r
  last_name: a
excerpt: !ruby/object:Hpricot::Doc
  options: {}
---
<p>Hey.</p>
<p>Recently I've heard that some people tend to see domain levelling quite different than the others. <br />I found it quite an interesting thing to check, that's why I'm writing this article.</p>
<p>Everybody knows that com, net, org are so called TLDs (Top-Level-Domains) and that they are part of the . (root) tree.<br />Not everybody knows that actually in the very prehistoric times, the notation was com. net. org. as to indicate that they have the root parent.<br />But that's only for curiosity.</p>
<p>Ok, so let's elaborate a bit...<br />
<!--more--></p>
<p>Let's take into account domain testdomain.com. <br />How many levels does this domain have? Two. Right.<br />First level is com, the second is testdomain.<br />That's quite obvious, isn't it?</p>
<p>Let's go further then. Copy, paste:</p>
<p> Let's take into account domain mysubdomain.testdomain.com. <br /> How many levels does this domain have? Three. Right again!</p>
<pre>.com</pre>
<pre>   |-&gt;.testdomain</pre>
<pre>        |-&gt; .mysubdomain</pre>
<p>True. So what's the problem? Here it is.</p>
<p>Let's take<em> www.mysubdomain.testdomain.com</em>.<br />How many levels does it have? 4? Right. 3? Wrong.<br />Some people tend to say that this is still a 3rd level domain. Why? I think I know why and here's the explanation.</p>
<p>I don't want to go into how DNS works but:</p>
<p>Let us assume that <em>www.mysubdomain.testdomain.com </em>resolves with DNS to 1.2.3.4.<br />Right. That means it has an <strong>A</strong> record in DNS for zone <em>mysubdomain.testdomain.com</em>. Right? Wrong.<br />It can have. But it can have a <strong>CNAME </strong>record as well.<br />That's the confusion. <strong>Some people tend to say that <em>www  </em>here is an alias. An alias then, is actually a CNAME record, that is pointing to an A record (that does actually point the IP address).</strong></p>
<p>The point is. <u>It does not matter what record in the DNS you have, <strong>CNAME </strong>or<strong> A</strong>. It is still a valid DNS record, and if it designates another subdomain (yes, www here is a subdomain, it's not delegated though with <strong>NS </strong>record, but pointing to a specific IP address with <strong>A</strong> record), then it is separated with a '.' (dot) sign. Though it starts to be n+1 level in the hierarchic system.<br /></u></p>
<p>To say more, here are the examples of some weird (but sometimes useful) entries in the DNS system (this is for testdomain.com still):</p>
<div class="code">www         IN A 1.2.3.4</div>
<p>meaning <em>www.testdomain.com</em> is under 1.2.3.4 (3 level domain)</p>
<div class="code">www2 IN CNAME www</div>
<p>meaning <em>www2.testdomain.com</em> is under www.testdomain.com (that is under 1.2.3.4) (still 3 level)</p>
<div class="code">www.dev IN A 5.4.3.2</div>
<p> meaning <em>www.dev.testdomain.com</em> is under 5.4.3.2. Yes, this is a four-level-domain.</p>
<div class="code">otherdomain.testdomain.com IN NS 100.100.100.1</div>
<p>meaning 3rd level domain <em>otherdomain.testdomain.com </em>is delegated to a nameserver at ip 100.100.100.1.</p>
<p>If you are not convinced yet, then here are some RFC proofs:</p>
<p>  RFC2606:<br /> 
<div class="code">The global Internet Domain Name System is documented in [RFC 1034,<br />   1035, 1591] and numerous additional Requests for Comment.  It defines<br />   a tree of names starting with root, ".", immediately below which are<br />   top level domain names such as ".com" and ".us". Below top level<br />   domain names there are normally additional levels of names.</div>
<p>http://en.wikipedia.org/wiki/Domain_name#Other-level_domains</p>
<div class="code">In addition to the top-level domains, there are second-level domain (SLD) names. These are the names directly to the left of .com, .net, and the other top-level domains. As an example, in the domain en.wikipedia.org, "wikipedia" is the second-level domain.</p>
<p>On the next level are third-level domains. These domains are immediately to the left of a second-level domain. In the en.wikipedia.org example, "en" is a third-level domain. There can be fourth and fifth level domains and so on, with virtually no limitation. An example of a working domain with five levels is www.sos.state.oh.us. Each level is separated by a dot or period symbol between them.</p>
<p>Domains of third or higher level are also known as subdomains, though this term technically applies to a domain of any level, since even a top-level domain is a "subdomain" of the "root" domain (a "zeroth-level" domain that is designated by a dot alone).</p>
<p>Traditionally, the second level domain was the name of the company or the name used on the internet. The third level was commonly used to designate a particular host server. Therefore, ftp.wikipedia.org might be an FTP server, www.wikipedia.org would be a World Wide Web Server, and mail.wikipedia.org could be an email server. Modern technology now allows multiple servers to serve a single subdomain, or multiple protocols or domains to be served by a single computer. Therefore, subdomains may or may not have any real purpose.</p></div>
<p>RFC1034:</p>
<div class="code">When a user needs to type a domain name, the length of each label is<br />omitted and the labels are separated by dots (".").  Since a complete<br />domain name ends with the root label, this leads to a printed form which<br />ends in a dot.  We use this property to distinguish between:</p>
<p>   - a character string which represents a complete domain name<br />     (often called "absolute").  For example, "poneria.ISI.EDU."</p>
<p>   - a character string that represents the starting labels of a<br />     domain name which is incomplete, and should be completed by<br />     local software using knowledge of the local domain (often<br />     called "relative").  For example, "poneria" used in the<br />     ISI.EDU domain.</p>
<p>Relative names are either taken relative to a well known origin, or to a<br />list of domains used as a search list.  Relative names appear mostly at<br />the user interface, where their interpretation varies from<br />implementation to implementation, and in master files, where they are<br />relative to a single origin domain name.  The most common interpretation<br />uses the root "." as either the single origin or as one of the members<br />of the search list, so a multi-label relative name is often one where<br />the trailing dot has been omitted to save typing.</p>
<p>To simplify implementations, the total number of octets that represent a<br />domain name (i.e., the sum of all label octets and label lengths) is<br />limited to 255.</p>
<p>A domain is identified by a domain name, and consists of that part of<br />the domain name space that is at or below the domain name which<br />specifies the domain.  A domain is a subdomain of another domain if it<br />is contained within that domain.  This relationship can be tested by<br />seeing if the subdomain's name ends with the containing domain's name.<br />For example, A.B.C.D is a subdomain of B.C.D, C.D, D, and " ".</div>
