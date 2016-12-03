---
layout: post
title: Running Redmine under unicorn in Debian
date: 2011-01-07 13:01:57.000000000 +00:00
categories:
- Linux
---
This post explains how to set up Redmine - the packaged version in Debian, to be hosted by Unicorn server and to use apache load balancing module.
This is a faster alternative to running Redmine with mod_passenger.

The idea is as follows: unicorn is starting X servers running Redmine, and Apache is load-balancing the requests between those servers.
We have to start with installation of unicorn gem
{% highlight bash %}gem install --no-ri --no-rdoc unicorn{% endhighlight %}
Now, we have to creation Unicorn configuration file:
{% highlight bash %}
working_directory "/usr/share/redmine"
pid "/tmp/redmine.pid"
preload_app true
timeout 60
worker_processes 4
listen 4000
GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true
after_fork do |server, worker|
        #start the worker on port 4000, 4001, 4002 etc...
        addr = "0.0.0.0:#{4000 + worker.nr}"
        # infinite tries to start the worker
	server.listen(addr, :tries => -1, :delay => -1, :backlog => 128)
        #Drop privileges if running as root
        worker.user('www-data', 'www-data') if Process.euid == 0
endand so on...
{% endhighlight %}
Before we try to start Redmine, we have to create a symlink to the logs directory:
{% highlight bash %}
ln -s /var/log/redmine/default/ /usr/share/redmine/log
{% endhighlight %}
Now, we can start Redmine and test if it works:
{% highlight bash %}
/usr/bin/unicorn_rails -E production -c /etc/redmine.ru --path '/redmine'
{% endhighlight %}
Note: Change the /redmine path to the path you want your Redmine should be visible at. This is needed for correct URL operations.
If everything is running smoothly, you can start the server with su and add the line to /etc/rc.local:
{% highlight bash %}
su -c "/usr/bin/unicorn_rails -E production -c /etc/redmine.ru --path '/support' -D" www-data
{% endhighlight %}
This is starting Unicorn initially as www-data user.
Apache 2 Balancer configuration
In this step, we tell Apache how to route requests to Redmine between the workers.
Firstly, let's enable the appropriate modules:
{% highlight bash %}
a2enmod balancer proxy proxy_http
{% endhighlight %}
Next, edit an appropriate VirtualHost configuration file. In the default configuration it would be /etc/apache2/sites-available/default and add the corresponding lines:
{% highlight bash %}
   SetEnv X_DEBIAN_SITEID "default"
    <Proxy balancer://redmine>
        BalancerMember http://127.0.0.1:4000
        BalancerMember http://127.0.0.1:4001
        BalancerMember http://127.0.0.1:4002
        BalancerMember http://127.0.0.1:4003
    </Proxy>
    Alias "/redmine/plugin_assets/" /var/cache/redmine/default/plugin_assets/
    RewriteEngine On
    RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_URI} !^.*plugin_assets.*$
    RewriteRule ^(/redmine/.*)$ balancer://redmine$1 [P,QSA,L]
    <Location /redmine/sys>
        Order deny,allow
        Deny from all
        allow from 1.2.3.4
        allow from 1.2.3.5
    </Location>
{% endhighlight %}
A little bit of description:

The SetEnv part is needed for Redmine Debianized configuration to choose the instance of Redmine
Proxy section defines the balancing workers to be used, be sure to adjust this if you are starting less/more worker threads
The Alias line is needed for some static files used by Redmine
The Rewrite section eventually tells Apache to route all Redmine requests to the load balance by matching /redmine/ against $REQUEST_URI variable.
The Location part is for the Redmine Web Service security. Adjust this to limit the access to the /redmine/sys/ only for the trusted servers.

