---
layout: post
title: Debian I/O disk problem when rebooting on XenServer guest
date: 2012-04-10 21:04:42.000000000 +00:00
categories:
- Linux
- kernel
- xenserver
---

Problem:

* You are using a XenServer machine that is running kernel somewhere around version 2.6.32
* You have a guest system like Debian Wheezy (currently testing) that is running kernel 3.0+
* While rebooting your guest system (VM) you are experiencing disk issues like I/O access, ext4 inconsistency, etc...
* The disks on guest are not mounting properly or are mounted in read-only mode or fsck has problems checking them

Solution:

In the HOST logs you can see probably:
{% highlight bash %}
Apr 10 11:04:14 server kernel: blkfront: xvda: barriers enabled
{% endhighlight %}

The problem is that 3.0 kernels are not using barriers anymore and there is a bug connected to that with the host kernel.
If you are interested in details, check out Debian bug #637234.

The workaround is to use 'barriers=0' while mounting the disks in the guest system, so you correct your /etc/fstab to have:
{% highlight bash %}
/dev/xvda1        /        ext4      errors=remount-ro,barrier=0      0     1
{% endhighlight %}
