---
layout: post
title: 'Atlassian JIRA: easily refreshing your testing instance from production'
date: 2014-10-17 00:46:49.000000000 +00:00
categories:
- Other
tags: []
status: draft
type: post
published: false
meta:
  _syntaxhighlighter_encoded: '1'
  _oembed_9a974b4017ef445a30ad8c1e0cb6d748: "{{unknown}}"
  _edit_last: '6'
  videourl: ''
author:
  login: radek.antoniuk@gmail.com
  email: radek.antoniuk@gmail.com
  display_name: warden
  first_name: r
  last_name: a
excerpt: !ruby/object:Hpricot::Doc
  options: {}
---

{% highlight bash %}
#!/bin/bash
JIRA_USER=jira
PROD_SERVER=hostname
echo "JIRA stopping"
/etc/init.d/jira stop
echo "Refreshing JIRA DB"
echo "------------------"
mysql -e'DROP DATABASE jira;'
mysql -e' CREATE DATABASE `jira` DEFAULT CHARACTER SET utf8; '
mysqldump --skip-events --single-transaction jira -h $PROD_SERVER -utest -ptest| mysql jira
echo "Rsyncing files"
rsync -avz --delete --exclude 'temp/' --exclude 'logs/' --copy-links rsync://$PROD_SERVER/sync/jira-current /data/
rsync -avz --delete --exclude 'temp/' --exclude 'logs/' --exclude 'log/' rsync://$PROD_SERVER/sync/jira-data /data/
echo "Disabling JIRA notifications"
sed -ie 's/#DISABLE_NOTIFICATIONS/DISABLE_NOTIFICATIONS/1' /opt/jira-current/bin/setenv.sh
echo "Recreate ignored directories"
mkdir /data/jira-current/logs &amp;&amp; chown $JIRA_USER:$JIRA_USER /data/jira-current/logs/
mkdir /data/jira-data/log &amp;&amp; chown $JIRA_USER:$JIRA_USER /data/jira-data/log/
echo "JIRA starting"
#/etc/init.d/jira start
{% endhighlight %}
echo "Changing DB user/pass"
sed -ie 's/dummy/dummy/1' /data/jira-data/dbconfig.xml
sed -ie 's/
dummy/
dummy/1' /data/jira-data/dbconfig.xml
Reference:
https://confluence.atlassian.com/display/JIRAKB/How+to+Prepare+a+Development+Server's+Mail+Configuration
