---
layout: post
title: 'Puppet: send an email to the client when a new key is generated'
date: 2012-09-05 23:05:16.000000000 +00:00
categories:
- Automation
tags:
- puppet
- CI/CD
- ssh
---
Puppet is great for centralised management of SSH keys on Linux boxes. The SSH module described in the project pages does its job really well for creating a new key pair and distributing it for clients (using the keys) and servers (authorized_keys file management).

The key generation mechanism provides several options to set up how the keys should be generated. One of them, is the maxdays options, defining how long the keys are valid. Because of that, I needed some mechanism to notify the users when their key has changed and they need to fetch new one. Normally, ssh::auth::server can be used for private key distribution, sometimes however this is not possible and that's why this need floated.

To solve that, I thought that the simplest way will be to send an email that is set in the account properties.
Basically the most crucial code needed is this one:

{% highlight ruby %}
   exec { "Create key $title: $keytype, $length bits":
      command => "ssh-keygen -t ${keytype} -b ${length} -f ${keyfile} -C \"${keytype} ${length}\" -N \"\"",
      user    => "puppet",
      group   => "puppet",
      creates => $keyfile,
      require => File[$keydir],
      before  => [File[$keyfile, "${keyfile}.pub"],Exec["Notify user ${email}"]]
    }
    exec { "Notify user ${email}":
        command => "cat ${keyfile} | mail -s 'New SSH key notification' ${email}",
        subscribe => Exec["Create key $title: $keytype, $length bits"],
        refreshonly => true
    }
{% endhighlight %}

The command for user notification is in the exec clause and it is using a simple mail command.

The full diff of modules/ssh/manifests/auth.pp is below:
{% highlight bash %}
Index: modules/ssh/manifests/auth.pp
===================================================================
--- modules/ssh/manifests/auth.pp
+++ modules/ssh/manifests/auth.pp
@@ -22,7 +22,7 @@
 # is done in the private definitions called by the virtual resources:
 # ssh_auth_key_{master,server,client}.                                
-define key ($ensure = "present", $filename = "", $force = false, $group = "puppet", $home = "", $keytype = "rsa", $length = 2048, $maxdays = "", $mindate = "", $options = "", $user = "") {
+define key ($ensure = "present", $filename = "", $force = false, $group = "puppet", $home = "", $keytype = "rsa", $length = 2048, $maxdays = "", $mindate = "", $options = "", $user = "", $email="") {                                                                                                                                                    
   ssh_auth_key_namecheck { "${title}-title": parm => "title", value => $title }
@@ -44,6 +44,7 @@
     length  => $_length,
     maxdays => $maxdays,
     mindate => $mindate,
+    email   => $email
   }
   @ssh_auth_key_client { $title:
     ensure   => $ensure,
@@ -144,7 +145,7 @@
 # This definition is private, i.e. it is not intended to be called directly by users.
 # ssh::auth::key calls it to create virtual keys, which are realized in ssh::auth::keymaster.
-define ssh_auth_key_master ($ensure, $force, $keytype, $length, $maxdays, $mindate) {
+define ssh_auth_key_master ($ensure, $force, $keytype, $length, $maxdays, $mindate, $email) {
   Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin" }
   File {
@@ -212,8 +213,14 @@
       group   => "puppet",
       creates => $keyfile,
       require => File[$keydir],
-      before  => File[$keyfile, "${keyfile}.pub"],
-    }
+      before  => [File[$keyfile, "${keyfile}.pub"],Exec["Notify user ${email}"]]
+    }
+
+    exec { "Notify user ${email}":
+       command => "echo 'A new SSH key for you has just been generated. Please fetch it from the server.' | mail -s 'New SSH key notification' ${email}",
+       subscribe => Exec["Create key $title: $keytype, $length bits"],
+       refreshonly => true
+    }
   } # if $ensure  == "present"
{% endhighlight %}
