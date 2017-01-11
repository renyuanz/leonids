---
layout: post
title: RVM, Passenger 3, REE, Rails3 in a Debian
date: 2011-01-03 03:16:23.000000000 +00:00
categories:
- Linux
- Rails
tags:
- passenger
- ree
- ruby
- rvm
--
This post explains how to install a global RVM (Ruby Version Manager) with Passenger 3 gem, Ruby Enterprise Edition in a Debian server machine for all users.

1. Create /etc/rvmrc with the contents:
{% highlight bash %}
export rvm_path=&quot;/opt/rvm&quot;
export rvm_source_path=&quot;${rvm_path}/src&quot;
export rvm_log_path=&quot;${rvm_path}/log&quot;
export rvm_bin_path=&quot;${rvm_path}/bin&quot;
export rvm_gems_path=&quot;$rvm_path/gems&quot;
export rvm_tmp_path=&quot;${rvm_tmp_path:-&quot;$rvm_path/tmp&quot;}&quot;
export rvm_install_on_use_flag=0
export rvm_gemset_create_on_use_flag=0
# export rvm_make_flags=&quot;-j7&quot;
export rvm_trust_rvmrcs_flag=1
export rvm_pretty_print_flag=1
{% endhighlight %}
I have chosen /opt/rvm/ for the installation.
2. To install RVM, use the cool script provided on rvm's site:
{% highlight bash %}
bash &lt; &lt;(curl http://rvm.beginrescueend.com/releases/rvm-install-head)
{% endhighlight %}
3. To enable RVM in the command-line, add this to /etc/profile at the very end:
{% highlight bash %}
[[ -s &quot;/opt/rvm/scripts/rvm&quot; ]] &amp;&amp; source &quot;/opt/rvm/scripts/rvm&quot;
{% endhighlight %}
Be sure to modify the path /opt/rvm if you have installed rvm elsewhere.
4. Re-login to enable rvm command.
Now we have RVM environment installed and we will take care of Ruby Enterprise Edition.
1. Installing Ruby Enterprise Edition
{% highlight bash %}
rvm install ree
{% endhighlight %}
2. Installing Passenger 3.
{% highlight bash %}
rvm ree
#installing the gem
gem install passenger
#compiling Apache2 module
passenger-install-apache2-module
{% endhighlight %}
3. Now add/change the paths how Passenger is loaded in /etc/apache2/mods-available/ in the files passenger.load and passenger.conf:
{% highlight bash %}
#passenger.load
LoadModule passenger_module /opt/rvm/gems/ree-1.8.7-2010.02/gems/passenger-3.0.2/ext/apache2/mod_passenger.so
#passenger.conf
PassengerRoot /opt/rvm/gems/ree-1.8.7-2010.02/gems/passenger-3.0.2
PassengerRuby /opt/rvm/wrappers/ree-1.8.7-2010.02/ruby
{% endhighlight %}
Next enable the module with a2enmod passenger and restart apache.
You can verify if Passenger started with grep:
{% highlight bash %}
server:~# ps aux | grep Passenger
root     10515  0.0  0.3   4164  1676 ?        Ssl  02:25   0:00 PassengerWatchdog
root     10519  0.0  0.3  12868  1920 ?        Sl   02:25   0:00 PassengerHelperAgent
root     10521  0.1  1.5  17720  7812 ?        S    02:25   0:00 Passenger spawn server
nobody   10524  0.0  0.6   9504  3088 ?        Sl   02:25   0:00 PassengerLoggingAgent
{% endhighlight %}
4. Next, we will make the REE the default environment and create a default gemset.
{% highlight bash %}
#switch to REE
rvm use ree
#create the gemset
rvm gemset create default
#use the gemset and set it as default
rvm use ree@default --default
#install rails3 in the gemset
gem install rails3
{% endhighlight %}
If you want normal users to be able to create gemsets and install additional gems, you have to change permissions of /opt/rvm/gems/.
This is not very elegant and super-safe solution, but for development machines is ok.
{% highlight bash %}
chmod -R 777 /opt/rvm/gems/
{% endhighlight %}
Using RVM in CRON
If you try to use RVM in cron the normal way, like:
{% highlight bash %}
37 * * * *      /bin/bash -l -c &quot;RAILS_ENV=production /opt/rvm/bin/rake db:backup;&quot;
{% endhighlight %}
You will end up with one of the following errors:

command rvm is not found
command rake is not found
gem XXX is not found

This is due to the fact, that cron commands are run in a very limited environment whereas RVM heavily relies on the environment variables.
As a remedy for that situation, you have to invoke bash as if it was invoked by a login shell:
{% highlight bash %}
38 * * * * 	/bin/bash -l -c &quot;cd project; RAILS_ENV=production rake db:backup;&quot;
{% endhighlight %}
Explanation:

-l is invoking bash with full environment for RVM to work properly. Remember to put the appropriate RVM loading line in the .bashrc !
-c says read the command from the parameter
next in the command, you cd to the project directory; this is needed to set up proper RVM environment from the .rvmrc file - so yes, I am assuming you have a file named .rvmrc in your project directory inside which you are selecting the proper gemset

