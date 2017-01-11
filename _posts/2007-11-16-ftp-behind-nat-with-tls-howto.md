---
layout: post
title: FTP behind NAT with TLS howto
date: 2007-11-16 01:51:44.000000000 +00:00
categories:
- Linux
tags:
- HowTo
- FTP
- NAT
- TLS
---
<p>Ever wondered how to set up a more secure FTP server?<br />
I did. And the first thing that came to my mind was getting those username/password things encrypted.<br />
Who did invent a plaintext login mechanism!?<br />
Sheeesh...</p>
<p>So, let's get started.<br />
This howto will tell you how to set up an Proftpd based FTP server with TLS encryption for data&amp;control channels.<br />
<!--more--></p>
<p>Firstly, I assume that you have a working proftpd installation.<br />
You can get it simply by:</p>
<pre>apt-get install proftpd</pre>
<p>So, you should be able to login to the server and sniff your credentials using i.e. <em>tcpdump </em>or <em>tcpick</em>.<br />
Anyway, now we want to go into TLS stuff.<br />
Firstly, let's set up a plain TLS configuration.<br />
Edit your /etc/proftpd/proftpd.conf, and add the following section:</p>
<pre>TLSEngine on
TLSProtocol TLSv1
TLSRequired off
TLSRSACertificateFile ftpcert.pem
TLSRSACertificateKeyFile ftpcert.pem
TLSCACertificateFile cacert.pem
TLSVerifyClient off
TLSRenegotiate required off
</pre>
<p>Of course, you have to set proper paths to your Certificate and Key files (and CA certificate file as well).<br />
Now. You can <strong>force</strong> all clients to use TLS encryption, with TLSRequired option. However, be sure that all clients are aware of it, because otherwise, they will be unable to log in (with most of the FTP clients).<br />
For instance, Total Commander now supports FTP w/TLS (since version 7.02 I think), but you have to add openssl.dll to it's installation dir.<br />
Furthermore, decide if you want to use any Verification mechanism for your certificate (TLSVerifyClient directive).<br />
TLSRenegotiate is used to keep some buggy clients happy, as they break during renegotiation session.</p>
<p>Now, do a restart and providing that you've enabled the mod_tls module, you have TLS working.<br />
You can be happy now, but read further as you will probably encounter some problems later.</p>
<p>All seems quite well when you test your installation without NAT.<br />
The problems start to show up when NAT goes into action.<br />
Probably you will encounter the 'hanging listing' problem? :)</p>
<p>So, there is a number of issues here to check.</p>
<ul>
<li>If you are not able to get your FTP listing even without TLS, check if you have appriopriate modules loaded into kernel:</li>
</ul>
<pre>host:~# lsmod | grep ftp
ip_nat_ftp              3200  0
ip_nat                 16172  3 ip_nat_ftp,ipt_MASQUERADE,iptable_nat
ip_conntrack_ftp        7280  1 ip_nat_ftp
ip_conntrack           46644  6 ip_nat_ftp,ipt_MASQUERADE,xt_state,iptable_nat,ip_nat,ip_conntrack_ftp
</pre>
<ul>
<li>if your listing works ok with NAT wo/TLS, but it doesn't w/TLS, then you got to the point that I struggled. So I will explain a bit. While using NAT, you start to use Passive Mode (PASV). In this mode, the FTP server, is starting to communicate via some high-ranged ports mapped accordingly to the established connection (source,destination) on the stateful firewall (iptables). In a non-TLS scenario that firewall's nat_ftp module is aware of the ports that FTP server is using for the PASV mode (as it looks up the PASV commands inside the packets traversed). The problem appears when you start using TLS mode. Then, the firewall is unable to see the ports anymore, because the packets and control channel is encrypted. And we have a problem. Solution? Here it is:</li>
</ul>
<p>I'm assuming that you are using iptables, that your policy is DROP on the INPUT chain, and that you have permitted RELATED,ESTABLISHED and all traffic to port 20,21 (standard ftp ports). Now. Add the following line to you protftpd.conf:</p>
<pre>PassivePorts 50000 51000
</pre>
<p>What does it do? It tells the server to use this explicit range of ports when establishing FTP PASV connection. This way we know which ports it will use.<br />
Now the only thing you can do to get it working is opening those ports on firewall:</p>
<pre>iptables -I INPUT -m state --state NEW -j ACCEPT -p tcp -m multiport --ports 50000:51000
</pre>
<p>Voila! It should work now!</p>
<p>One more thing. If you have a lot of FTP clients/traffic, consider widening this range, as you may run out of the ports that can be assigned to users (when many of them are connecting simultaneously).</p>
