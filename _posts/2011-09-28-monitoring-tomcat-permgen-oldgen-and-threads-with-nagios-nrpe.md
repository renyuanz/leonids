---
layout: post
title: Monitoring Tomcat PermGen, OldGen and Threads with Nagios nrpe
date: 2011-09-28 00:37:01.000000000 +00:00
categories:
- Nagios
---
Today I am sharing with you a Nagios Perl script for monitoring Tomcat through JMX.
This script can be used for monitoring Tomcat server parameters through Nagios NRPE server.
Script can be found here. It is not all parametrised with the command line, but can be easily adapted to monitor other parameters and/or display other PerfData.
As you can see in the source, the script is checking for 3 different params for PermGen:
- Perm Gen
- PS Perm Gen
- CMS Perm Gen
This is because Tomcat can use different Garbage Collectors (see this answer).
