---
layout: post
title: Creating Debian Lenny Bootable USB key in Windows
date: 2009-06-01 22:51:55.000000000 +00:00
categories:
- Linux
tags:
- bootable
- cd
- debian
- error
- grub
- Linux
- stick
- usb
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  _sexybookmarks_shortUrl: http://b2l.me/anrten
  _sexybookmarks_permaHash: 428dcd1aeeb9319833265272eab26881
author:
  login: radek.antoniuk@gmail.com
  email: radek.antoniuk@gmail.com
  display_name: warden
  first_name: r
  last_name: a
excerpt: !ruby/object:Hpricot::Doc
  options: {}
---
<p>Today I had to recover a machine from a disastrous power failure (yes, I had a UPS but it didn't manage :P).<br />
The results was as usual:</p>
<pre colla="+">
Kernel panic: Not syncing!!
/sbin/init not found
</pre>
<p>Doesn't sound nice, does it? It wasn't. My whole /lib was gone...<br />
I had to boot with root mounted to my disk (which I failed with, because /bin/bash was not working, but that's another story), and I didn't have a CD, so I had to create a bootable USB key.<br />
Unfortunately all articles on Debian Live and stuff didn't work.. so.. here is how it worked for me in two simple steps.<br />
<!--more--><br />
The prerequisites are:</p>
<ul>
<li>download <a href="http://ftp.pl.debian.org/debian/dists/lenny/main/installer-i386/current/images/hd-media/boot.img.gz">boot.img.gz</a> from <a href="http://ftp.pl.debian.org/debian/dists/lenny/main/installer-i386/current/images/hd-media/" target="_blank">current Debian installer</a></li>
<li>download the <a href="http://cdimage.debian.org/debian-cd/5.0.1/i386/iso-cd/debian-501-i386-netinst.iso">installation image</a> for you. I have used the netinst version, but you can use businesscard if you want.</li>
<li><a href="http://www.chrysocome.net/dd" target="_blank">dd for windows</a> ;-)</li>
</ul>
<p>Now that you have everything:</p>
<ol>
<li>unpack your boot.img.gz.</li>
<li>copy it to your usb stick with dd, like this:</li>
<pre colla="+"> dd if=boot.img of=\.\g: bs=512k</pre>
<li>copy netinst.iso to your USB stick ( via ordinary windows explorer )</li>
</ol>
<p>That's it. Now you should have a working bootable Debian USB stick. Remeber to change the boot order in your BIOS <strong>after </strong> plugging in the stick!</p>
