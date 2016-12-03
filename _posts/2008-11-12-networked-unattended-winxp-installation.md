---
layout: post
title: Networked Unattended WinXP installation
date: 2008-11-12 13:14:15.000000000 +00:00
categories:
- Other
- network
- oem
- preinstallation
- unattended
- windows
---
<p>Hola!</p>
<p>Recently I have been doing an XP preinstallation for a remote software deployment project. In this post i'm putting all the interesting links I have found and the problems I had during the software preparation.</p>
<p>This is NOT a howto or instruction, this is just intended to help. If you want to have a full howto, don't hesitate to comment/fund a coffee for me :)<br />
<!--more--></p>
<p>As a hint, the project is to deploy a networked Windows XP installation from a Linux machine. But, warning, deploy <strong>an installation</strong>, not an image :) For this urpose, I have used a project called <a title="OPSI" href="http://opsi.org" target="_blank">OPSI.</a> Thanks guys for really great work!</p>
<p>General knowledge articles:</p>
<ul>
<li><a href="http://support.microsoft.com/?kbid=288344" target="_blank">How to create an unattended installation of third-party mass storage drivers in Windows 2000</a></li>
<li><a href="http://support.microsoft.com/kb/155197" target="_blank">HOWTO: Unattended Setup Parameters for Unattend.txt File</a></li>
<li><a href="http://msdn.microsoft.com/en-us/library/ms940862.aspx" target="_blank">Preventing Plug and Play</a></li>
<li><a href="http://msdn.microsoft.com/en-us/library/ms940850.aspx " target="_blank">Enabling Default Reply</a></li>
<li><a href="http://unattended.msfn.org/unattended.xp/view/web/24/" target="_blank">Integrating Service Packs</a></li>
<li><a href="http://support.microsoft.com/kb/824687/" target="_blank">Command-line switches for Microsoft software update packages</a></li>
<li><a href="http://technet.microsoft.com/en-us/library/bb457114.aspx" target="_blank">WRK: Understanding Logon and Authentication </a></li>
<li><a href="http://www.nliteos.com/download.html" target="_blank">NLite : drivers integration</a></li>
<li><a href="http://www.adobe.com/support/downloads/detail.jsp?ftpID=3564" target="_blank">Adobe Reader unattended deployment</a></li>
<li><a href="http://technet.microsoft.com/en-us/library/dd197418.aspx" target="_blank">Windows DNS Registry Entries</a></li>
<li><a href="http://technet.microsoft.com/en-us/library/aa998420.aspx" target="_blank">The computer's primary DNS suffix does not match the FQDN of the domain where it resides</a></li>
</ul>
<p>There were some problems that I have encountered during the preparations of the preinstallation. Here is a short list of them, and how they were solved:</p>
<ol>
<li>SoundMAX drivers did not detect at all. This has been solved by <a href="http://support.microsoft.com/default.aspx/kb/888111 " target="_blank">KB888111</a> which makes Universal Audio Architecture (UAA) High Definition Audio detect properly during setup. Additionally, the SoundMAX software has to be installed AFTER the system installation has completed (via <a href="http://download.uib.de/opsi_stable/doku/winst_manual.pdf" target="_blank">winstscript</a>)</li>
<li>During the installation, an "Add new hardware" wizard popped up because of Video card detection. This has been solved by <a href="http://support.microsoft.com/kb/883667" target="_blank">KB883667</a></li>
</ol>
<p>Notes:</p>
<ul>
<li>Some of the KB patches have been integrated with /integrate option into the i386 source tree, but some failed and were added manually.</li>
<li>I have integrated SP3 manually using the SVCPACK.INF method</li>
</ul>
