---
layout: post
title: 'Mantis tweaks: logging in via Microsoft Active Directory LDAP'
date: 2008-07-08 14:30:23.000000000 +00:00
categories:
- Linux
tags:
- development
- mantis
---
This is a short article on how to get the above Mantis version to work with Microsoft Windows Active Directory LDAP.
Used Mantis version: 1.1.1 and PHP Version 5

Mantis currently supports only login via LDAP directory by the following scheme:

Connect to LDAP server
Bind with anonymous DNS or with a user specified DN (but in a config file permanently)
If the bind succeeds then do an ldap_search
If the search succeeds then login is successful.

When using Microsoft AD LDAP the situation is a bit different, we want to:

# Connect to LDAP server

Create a DN basing on the config file and username field that  the user entered in the login form
Try Bind with the above DN and password that the user entered in the login form
If the bind succeeds then the login is successful (we don't need to run the search)

To achieve that, there are some minor changes to do in the Mantis core API.

## Step 1

Log in to a fresh mantis installation, and create a user with admin privileges with a username matching your LDAP username (in this example xy2093)

## Step 2

First, add to your config_inc.php configuration file the following options:

{% highlight php %}

/* we want to use LDAP auth */

$g_login_method = LDAP;
$g_ldap_server = 'ldap://ldap.myhost.com/';

/* the root DN that will be used to form the bind DN during authentication phase */
$g_ldap_root_dn = 'ou=staff,ou=company,dc=domain,dc=com';

/* we don't want the users to be able to sign-up via mantis */
$g_allow_signup=OFF;

/* we want to use Mantis email field instead of LDAP one */
$g_use_ldap_email = OFF;

/* we don't want false mantis lost password feature */
$g_lost_password_feature = OFF;
{% endhighlight %}

## Step 3:

Next, you have to modify the core LDAP authentication ldap_authenticate function. Go to core/ldap_api.php, find the above function and replace it with:

{% highlight php %}

function ldap_authenticate( $p_user_id, $p_password ){
if (is_blank($p_password))
return false;
$t_ldap_host = config_get('ldap_server');
$t_ldap_port = config_get('ldap_port');
$t_ldap_rdn = config_get('ldap_root_dn');
$t_ds = ldap_connect($t_ldap_host, $t_ldap_port) or die('Unable to connect to LDAP server&lt;br /&gt;');
$t_user = user_get_field($p_user_id, 'realname'); //This checks the users Real Name instead of username
$t_uname = user_get_field($p_user_id, 'username');
$binddn = "CN=$t_user ($t_uname),$t_ldap_rdn";
$t_authenticated = false;
if(@ldap_bind($t_ds,$binddn,$p_password))
$t_authenticated = true;

return $t_authenticated;
}
{% endhighlight %}

In the function notice the $bind_dn variable. This is the variable being used to prepare the bind DN for LDAP connection. Feel free to modify it to suit your authentication scheme, however you should not have to. It defaults to:

CN=Firstname Lastname (username),ou=staff,ou=company,dc=domain,dc=com

i.e.
CN=John Doe (xy2093),ou=staff,ou=company,dc=domain,dc=com.

You won't believe it but that's it! Now you can try to log in to Mantis with your LDAP password and it should work like a charm.

The next issue to solve here is that you have to have the users from LDAP in your $mantis_user_table, for instance to manage Mantis privileges. There are many ways to achieve that, you can import them every night. Or you can use Mantis SOAP API to check if the user exists in LDAP when they try to log in as I did. But how to do that is another article ;)
