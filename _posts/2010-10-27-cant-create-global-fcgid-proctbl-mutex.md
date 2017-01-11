---
layout: post
title: Can’t create global fcgid-proctbl mutex
date: 2010-10-27 15:30:30.000000000 +00:00
categories:
- Linux
tags:
- Apache
---
<p>You probably see this error when you are trying to start apache with /etc/init.d/apache2 start and there is no effect.<br />
This error is caused by not clearing semaphores by apache and/or mod_fcgid and/or mod_passenger.<br />
You can see the list of semaphores with the command <em>ipcs -s.</em></p>
<p><!--more--><br />
<code><br />
warden@host:~$ sudo ipcs -s<br />
[sudo] password for warden: </code></p>
<p><code> </code></p>
<p><code>------ Semaphore Arrays --------<br />
key        semid      owner      perms      nsems<br />
0x00000000 7798784    www-data   600        1<br />
0x00000000 7831553    www-data   600        1<br />
0x00000000 7864322    www-data   600        1<br />
0x00000000 7897091    www-data   600        1<br />
0x00000000 7929860    www-data   600        1<br />
0x00000000 7962629    www-data   600        1<br />
0x00000000 7995398    www-data   600        1<br />
0x00000000 8028167    www-data   600        1<br />
0x00000000 8060936    www-data   600        1<br />
0x00000000 8093705    www-data   600        1<br />
0x00000000 8126474    www-data   600        1<br />
0x00000000 8159243    www-data   600        1<br />
</code></p>
<p>If this number is too high, you'll see this error while trying up to start apache2.<br />
You can however use the command<em> ipcrm -s</em> ID to clear them out.<br />
To clear all semaphores for www-data user you can use bash loop:<br />
<code><br />
for i in `ipcs -s | grep www-data | awk '{print $2}'` ; do ipcrm -s $i; done<br />
</code><br />
Hope that helps :)</p>
