---
layout: post
title: Rails application crashing when trying to upload files with mod_passenger
date: 2010-10-27 14:25:47.000000000 +00:00
categories:
- Linux
- Rails
tags:
- crash
- passenger
- rails
- ruby
status: publish
type: post
published: true
meta:
  _edit_last: '6'
  _wp_old_slug: ''
  _sexybookmarks_shortUrl: 'File: /data/app/webapp/functions.php<br />Line: 7<br />Message:
    Can''t connect to local MySQL server through socket ''/var/run/mysqld/mysqld.sock''
    (11)'
  _sexybookmarks_permaHash: 58cb1c55c5a48b6b302d5f64edebf2c1
  _syntaxhighlighter_encoded: '1'
author:
  login: radek.antoniuk@gmail.com
  email: radek.antoniuk@gmail.com
  display_name: warden
  first_name: r
  last_name: a
excerpt: !ruby/object:Hpricot::Doc
  options: {}
---
<p>If you are using Ruby on Rails with Apache (or Apache ITK) and mod_passenger and you get an error while you are trying to upload a file through Rails application, you are probably facing the problem of wrong permissions set in the webserver_private directory of passenger.<br />
Passenger is not currently supporting ITK and is not changing the ownership of the files/dirs correctly.</p>
<p><!--more--><br />
The error is probably as follows:<br />
[code]<br />
[ pid=32497 file=ext/apache2/Hooks.cpp:727 time=2010-10-27 13:47:50.44 ]:<br />
Unexpected error in mod_passenger: An error occured while buffering HTTP upload data to a temporary file in /tmp/passenger.10064/webserver_private. The current Apache worker process (which is running as fainarete) doesn't have permissions to write to this directory. Please change the permissions for this directory (as well as all parent directories) so that it is writable by the Apache worker process.<br />
Backtrace:<br />
in 'boost::shared_ptr<br />
Hooks::receiveRequestBody(request_rec*, const char*)' (Hooks.cpp:1084)<br />
in 'int Hooks::handleRequest(request_rec*)' (Hooks.cpp:459)<br />
[/code]</p>
<p>You have to:</p>
<ul>
<li>create a <em>tmp</em> directory in your project directory (home directory or whatever, it should be placed outside of the application though)</li>
<li>set PassengerUploadBufferDir in the VirtualHost section of your Apache config to the path of the directory you have just created. Remember to give write access to the user the VirtualHost is running from (or 777 with suid).</li>
</ul>
