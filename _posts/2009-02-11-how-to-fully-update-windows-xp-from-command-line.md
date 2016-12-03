---
layout: post
title: How to fully update Windows XP from command-line?
date: 2009-02-11 18:45:46.000000000 +00:00
categories:
- Other
tags:
- opsi
- unattended
- update
- upgrade
- wsus
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  _sexybookmarks_shortUrl: http://b2l.me/angbhd
  _sexybookmarks_permaHash: 0428df6284c6427947b03268afdcdf5f
author:
  login: radek.antoniuk@gmail.com
  email: radek.antoniuk@gmail.com
  display_name: warden
  first_name: r
  last_name: a
excerpt: !ruby/object:Hpricot::Doc
  options: {}
---
<p>Recently I've needed to upgrade my PC from a command line.<br />
After a lot of searching, including Microsoft tech-support where I was told that it's not possible, I've managed to do it using Windows Scripting. Here is a VBS script that does the thing and <span style="text-decoration: underline;">reboots the machine afterwards</span>:</p>
<p><!--more--></p>
<div class="code">Set wshShell = WScript.CreateObject("WSCript.shell")<br />
wshShell.run "net stop wuauserv",0,True<br />
wshShell.run "net start wuauserv",0,True</p>
<p>Set updateSession = CreateObject("Microsoft.Update.Session")<br />
Set updateSearcher = updateSession.CreateupdateSearcher()</p>
<p>Set searchResult = updateSearcher.Search("IsInstalled=0 and Type='Software'")</p>
<p>For I = 0 To searchResult.Updates.Count-1<br />
Set update = searchResult.Updates.Item(I)<br />
Next</p>
<p>If searchResult.Updates.Count = 0 Then<br />
wshShell.run "shutdown -r -f -t 0"<br />
End If</p>
<p>Set updatesToDownload = CreateObject("Microsoft.Update.UpdateColl")</p>
<p>For I = 0 to searchResult.Updates.Count-1<br />
Set update = searchResult.Updates.Item(I)<br />
updatesToDownload.Add(update)<br />
Next</p>
<p>Set downloader = updateSession.CreateUpdateDownloader()<br />
downloader.Updates = updatesToDownload<br />
downloader.Download()</p>
<p>For I = 0 To searchResult.Updates.Count-1<br />
Set update = searchResult.Updates.Item(I)<br />
Next</p>
<p>Set updatesToInstall = CreateObject("Microsoft.Update.UpdateColl")</p>
<p>For I = 0 To searchResult.Updates.Count-1<br />
set update = searchResult.Updates.Item(I)<br />
If update.IsDownloaded = true Then<br />
updatesToInstall.Add(update)<br />
End If<br />
Next</p>
<p>Set installer = updateSession.CreateUpdateInstaller()<br />
installer.Updates = updatesToInstall<br />
installer.Install()</p>
<p>wshShell.run "shutdown -r -f -t 0"</p></div>
<p>Just paste it into script.vbs file and run.<br />
Hope helps somebody :)</p>
