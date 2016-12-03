---
layout: post
title: Mysql gem under MacOS Snow Leopard
date: 2010-11-15 02:42:25.000000000 +00:00
categories:
- MacOS
tags:
- gem
- mysql
- rails
---
<p>To set up this software under your Applebook, you have to download MySQL first. Go to <a href="http://dev.mysql.com/downloads/mysql/">MySQL download page</a> and fetch an appropriate version for your system, depending if it 32 or 64 bits.<br />
I'm having MacBook Pro with Intel Core 2 Duo.<br />
Ergo, this is 64-bit architecture, ergo, I've chosen to download <strong>Mac OS X ver. 10.6 (x86, 64-bit), DMG Archive.</strong><br />
<!--more--><br />
Now, launch the package and install all three things:</p>
<ol>
<li>mysql-5.1.52-osx10.6-x86_64.pkg -&gt; this is the MySQL server package</li>
<li>MySQL.prefPane -&gt; this is the System preferences tab, to control your MySQL server instance</li>
<li>MySQLStartupItem.pkg -&gt; this is the auto-startup for mysql. You can choose to auto-start the server or not later on, don't worry.</li>
</ol>
<p>Now, after you have done that, we can install the gem. If you try to do this the standard way with <em>sudo gem install mysql, </em>then you'll probably end up with the result similar to this:<br />
[sourcecode language="bash"]<br />
mac:dir mac$ sudo gem install mysql<br />
Building native extensions.  This could take a while...<br />
ERROR:  Error installing mysql:<br />
ERROR: Failed to build gem native extension.</p>
<p>/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby extconf.rb<br />
checking for mysql_query() in -l/usr/local/mysql/lib... no<br />
checking for main() in -lm... yes<br />
checking for mysql_query() in -l/usr/local/mysql/lib... no<br />
checking for main() in -lz... yes<br />
checking for mysql_query() in -l/usr/local/mysql/lib... no<br />
checking for main() in -lsocket... no<br />
checking for mysql_query() in -l/usr/local/mysql/lib... no<br />
checking for main() in -lnsl... no<br />
checking for mysql_query() in -l/usr/local/mysql/lib... no<br />
checking for main() in -lmygcc... yes<br />
checking for mysql_query() in -l/usr/local/mysql/lib... no<br />
*** extconf.rb failed ***<br />
Could not create Makefile due to some reason, probably lack of<br />
necessary libraries and/or headers.  Check the mkmf.log file for more<br />
details.  You may need configuration options.<br />
[/sourcecode]</p>
<p>This is due to the fact that the compiler couldn't find our custom mysql installation. To fix this error, try running the command below, supplying the paths:<br />
[sourcecode language="bash"]<br />
warden-mac:pirate mac15$ sudo env ARCHFLAGS=&quot;-arch x86_64&quot; gem install mysql --   --with-mysql-dir=/usr/local/mysql --with-mysql-lib=/usr/local/mysql/lib --with-mysql-include=/usr<br />
/local/mysql/include --with-mysql-config=/usr/local/mysql/bin/mysql_config<br />
Building native extensions.  This could take a while...<br />
Successfully installed mysql-2.8.1<br />
1 gem installed<br />
Installing ri documentation for mysql-2.8.1...<br />
(...)<br />
[/sourcecode]</p>
<p><strong>Warning!</strong><br />
Be sure to put the correct architecture name in the ARCHFLAGS environment variable.<br />
Otherwise, the gem will install correctly, but you'll get some errors like this from your rake:<br />
<em>uninitialized constant Mysql::Error</em></p>
<p>The correct values are:</p>
<ul>
<li> x86_64 for 64-bit system</li>
<li> x86 for 32-bit system</li>
</ul>
<p>of course, for Intel architecture.... :-)</p>
<p>This should do the trick, now you have your gem installed:<br />
[sourcecode language="bash"]mac:dir mac$ gem list | grep mysql<br />
mysql (2.8.1)<br />
[/sourcecode]</p>
<p>Good luck :)</p>
