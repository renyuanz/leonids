---
layout: post
title: Mysql gem under MacOS Snow Leopard
date: 2010-11-15 02:42:25.000000000 +00:00
categories:
- Software Development
tags:
- gem
- mysql
- rails
- macos
---
To set up this software under your Applebook, you have to download MySQL first. Go to http://dev.mysql.com/downloads/mysql/ and fetch an appropriate version for your system, depending if it 32 or 64 bits.
I'm having MacBook Pro with Intel Core 2 Duo.
Ergo, this is 64-bit architecture, ergo, I've chosen to download <strong>Mac OS X ver. 10.6 (x86, 64-bit), DMG Archive.

Now, launch the package and install all three things:

* mysql-5.1.52-osx10.6-x86_64.pkg - this is the MySQL server package
* MySQL.prefPane - this is the System preferences tab, to control your MySQL server instance
* MySQLStartupItem.pkg -this is the auto-startup for mysql. You can choose to auto-start the server or not later on, don't worry.

Now, after you have done that, we can install the gem. If you try to do this the standard way with sudo gem install mysql, then you'll probably end up with the result similar to this:
```
mac:dir mac$ sudo gem install mysql
Building native extensions.  This could take a while...
ERROR:  Error installing mysql:
ERROR: Failed to build gem native extension.

/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby extconf.rb
checking for mysql_query() in -l/usr/local/mysql/lib... no
checking for main() in -lm... yes
checking for mysql_query() in -l/usr/local/mysql/lib... no
checking for main() in -lz... yes
checking for mysql_query() in -l/usr/local/mysql/lib... no
checking for main() in -lsocket... no
checking for mysql_query() in -l/usr/local/mysql/lib... no
checking for main() in -lnsl... no
checking for mysql_query() in -l/usr/local/mysql/lib... no
checking for main() in -lmygcc... yes
checking for mysql_query() in -l/usr/local/mysql/lib... no
*** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of
necessary libraries and/or headers.  Check the mkmf.log file for more
details.  You may need configuration options.
```

This is due to the fact that the compiler couldn't find our custom mysql installation. To fix this error, try running the command below, supplying the paths:
```
warden-mac:pirate mac15$ sudo env ARCHFLAGS=&quot;-arch x86_64&quot; gem install mysql --   --with-mysql-dir=/usr/local/mysql --with-mysql-lib=/usr/local/mysql/lib --with-mysql-include=/usr
/local/mysql/include --with-mysql-config=/usr/local/mysql/bin/mysql_config
Building native extensions.  This could take a while...
Successfully installed mysql-2.8.1
1 gem installed
Installing ri documentation for mysql-2.8.1...
(...)
```

WARNING!

Be sure to put the correct architecture name in the ARCHFLAGS environment variable.
Otherwise, the gem will install correctly, but you'll get some errors like this from your rake:
uninitialized constant Mysql::Error
The correct values are:

*  x86_64 for 64-bit system
*  x86 for 32-bit system

of course, for Intel architecture.... :-)
This should do the trick, now you have your gem installed:

```
mac:dir mac$ gem list | grep mysql
mysql (2.8.1)
```

Good luck :)
