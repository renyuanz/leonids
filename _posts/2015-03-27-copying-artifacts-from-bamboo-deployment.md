---
layout: post
title: Copying Artifacts from Bamboo Deployment
date: 2015-03-27 17:18:08.000000000 +00:00
categories:
- Software Development
tags:
- CI
- CD
- Integration
- Delivery
---
Sometime we face the situation that we need to copy the deployment results (or Artifacts) to some central repository where all deployments are stored.
This is not a problem for Linux-to-Linux copy as we can use SCP, RSYNC or any other task.
What if the target is a Windows machine though and if we want to customize the directory naming to be dependent on e.g. version of the product hidden in the exe file?
PowerShell to the rescue!
We need two pieces:

We need a Bamboo Remote Agent that is running on a Windows box - this will be doing the deployment itself and executing the PowerShell script.
	
A powershell script Task (normal Script task with the Powershell type selected) and a script that will do the actual copy


{% highlight bash %}
$TODAY=(Get-Date).ToString('yyyy-MM-dd')
$VERSION=(dir Setup.Full.exe).VersionInfo.ProductVersion
$DIR=&quot;Z:\Releases\ProductName\$VERSION-$TODAY-${bamboo.deploy.release}\&quot;
Write-Host &quot;Saving artifacts to $DIR&quot;
New-Item -itemtype directory $DIR
Copy-Item * $DIR
{% endhighlight %}
What this script does is:

It sets current date to $TODAY variable
It takes setup.full.exe and pulls out version information from inside
It create a new directory in $DIR path
Copies all files from the current deployment bamboo agent directory to the target $DIR

