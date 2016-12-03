---
layout: post
title: Synchronizing Mailman lists with LDAP
date: 2010-02-01 23:35:07.000000000 +00:00
categories:
- Linux
- Postfix
---

Quite common usage scenario is a Postfix mail server with a Mailman instance for groups. Even more often the accounts for the mail are stored in an LDAP tree. And in this case a problem appears, because Mailman doesn’t have a native connection to LDAP. That’s why I needed to have an LDAP 2 Mailman script that would synchronise mailman groups with the LDAP tree. This Perl script is meant to be run from cron.

What this script does is the following:

* it binds to the LDAP server with the credentials provided at the beginning of the script
* it searches for objects of class mailGroup in the organizationalUnit ou=lists
* gets commonName (cn) of the object
* checks if the list of that name exists in mailman already
* gets all mail attributes values and all memberdn’s mail attributes values and updates the mailing list’s members with them

If the list does not exist, and  $create_nonexistent is true, then a new list will be automatically created with the admin/password defined in the variables at the beginning of the script.
Note: 
For security reasons, this version of the script DOES NOT delete lists, so if you delete a mailGroup from LDAP, you have to do a rmlist -a  by yourself. On request, I can give somebody the version which deletes the lists also.

The script relies on a mailGroup objectClass which is defined in the  schema that you can download from here.

{% highlight perl %}
#!/usr/bin/perl
###### LDAP-2-Mailman Synchronization script ######################################
# @author: Radek Antoniuk
# @website: http://www.warden.pl
# @license: GNU
#
# This script synchronises (adds/removes) the users from the Mailman mailing lists
# according to the objects found in LDAP. You can put it in cron. The script was
# written using Debian-style paths to Mailman, you may need to adjust them
# if you have a different mailman installation.
#
###################################################################################
use strict;
use warnings;
use Net::LDAP;

my $ldap_host = "ldap://localhost";
my $ldap_bind_dn = "cn=ldapuser,dc=domain,dc=com";
my $ldap_bind_pass = "password";
my $ldap_base_dn = "ou=lists,dc=domain,dc=com";

my $create_nonexistent = 1;
my $default_list_admin = 'admin@domain.com';
my $default_list_password = "111111";

# Connect to LDAP proxy and authenticate
my $ldap = Net::LDAP->new($ldap_host) || die "Can't connect to server\n";
$ldap->bind($ldap_bind_dn, password => $ldap_bind_pass) || die "Connected to server, but couldn't bind\n";

# search for interesting groups
my $ret = $ldap->search( base   => $ldap_base_dn,  filter => "(&(objectClass=mailGroup))" );
die "Search returned no groups\n" unless $ret;

print "\n\n";
print "------------------------------\n";

foreach my $group ($ret->entries) {

  my $member_emails = ""; #list of emails in the group
  my $list_name = $group->get_value("cn");

  if($list_name) {
    print "Processing list: $list_name \n";

    # get the membership list
    my @member_list = $group->get_value("member");

    # make a list of emails to pass to mailman from member objects
    foreach my $member_dn (@member_list) {
            my $person = $ldap->search(  base  => $member_dn, filter => "(&(mail=*)(!(pwdAccountLockedTime=*)))", scope => "base"  );
            # try to get the referred object, or continue if locked account or object does not exist #
            if (my $member = $person->entry(0)) {
               my $email = $member->get_value("mail");
               $member_emails .= $email."\n";
            }
    };

    # now process normal mail attributes #
    @member_list = $group->get_value("mail");

    foreach my $email (@member_list) {
            $member_emails .= $email . "\n";
    };

    # check if list exists
    if (! -d "/var/lib/mailman/lists/$list_name" ){
        print "List $list_name does not exist.\n";

        #if not and we want to create it automatically
        if ($create_nonexistent) {
                print "Creating new list $list_name.\n";
                qx{/usr/lib/mailman/bin/newlist -q $list_name $default_list_admin $default_list_password};
                # check if now the list exists
                die "FATAL: Unable to create list $list_name" if (! -d "/var/lib/mailman/lists/$list_name" );
        }

    }

    print "\nSyncing $list_name...\n";

    open( PIPE, "|/usr/lib/mailman/bin/sync_members -w=yes -g=yes -a=yes -f - $list_name" ) || die "Couldn't fork process! $!\n";
    print PIPE $member_emails;
    close PIPE;

    print "------------------------------\n";
  };
};

$ldap->unbind;
print "\n\n";{% endhighlight %}

