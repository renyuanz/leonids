---
layout: post
title: 'hints: using screen in linux'
date: 2010-05-30 13:05:24.000000000 +00:00
categories:
- Linux
tags:
- hostname
- screen
- ssh
- status
- window title
---
I am working a lot with screen, especially to get to remote hosts and do many operations at once.
The thing that was irritating me a lot, was the fact that I had to set the titles of windows manually after logging in via ssh.

I have found a method to overcome this problem though. Firstly, you have to put this line in your ~/.bashrc file.
{% highlight bash %}PROMPT_COMMAND='echo -ne &quot;&#92;&#48;33k$HOSTNAME&#92;&#48;33\\&quot;'{% endhighlight %}
Secondly, to get a nice status bottomline when you start screen, you have to set it in ~/.screenrc. I am using this set of customizations:
{% highlight bash %}# UTF-8 everywhere
defutf8 on
# disable Ctrl-S/Ctrl-Q &quot;flow control&quot;
defflow off
# skip intro
startup_message off
# detach on disconnect
autodetach on
# use regular audible bell
vbell off
# use backtick for prefix key instead of Ctrl-A
#escape ``
# print wackier status messages
nethack on
# restore window contents after using (e.g.) vi
altscreen on
#fancy statusbar
#shelltitle &quot;$ |bash&quot;
hardstatus alwayslastline '%{= kg}[ %{G}%H %{g}][%= %{= kw}%?%-Lw%?%{=b kR}(%{W}%n*%f %t%?(%u)%?%{=b kR})%{= kw}%?%+Lw%?%?%= %{g}][%{Y}%l%{g}]%{=b C}[ %d %M %c ]%{W}'{% endhighlight %}
Nothing better than a screenshot huh? Ok, here you are, THE RESULT:

