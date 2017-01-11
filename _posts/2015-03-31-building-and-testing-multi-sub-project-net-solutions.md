---
layout: post
title: Building and testing multi sub-project .NET solutions
date: 2015-03-31 12:41:43.000000000 +00:00
categories:
- Other
---
Assuming that we have a bigger Microsoft .NET project that has a structure like this:

{% highlight bash  %}
ROOT
  -- SubProject1
  -- SubProject1\SubProject1.sln
  -- SubProject1.Tests
  -- SubProject1.Tests\SubProject1.Tests.csproj
  -- SubProject2
  -- SubProject2\SubProject1.sln
  -- SubProject2.Tests
  -- SubProject2.Tests\SubProject2.Tests.csproj
  -- SubProject3
  -- SubProject3\SubProject1.sln
  -- SubProject3.Tests
  -- SubProject3.Tests\SubProject2.Tests.csproj
{% endhighlight %}

we can build it at once using MSBuild. Lets create a *builder.proj* file


{% highlight bash %}
<?xml version="1.0" encoding="utf-8"?>
<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003" >
<ItemGroup>
	<Solution Include="**\*.sln" />
</ItemGroup>
<ItemGroup>
	<TestAssemblies Include="**\**\bin\**\*Tests.dll"/>
</ItemGroup>
<Target Name="Build">
  <MSBuild Projects="@(Solution)" Targets="Build"/>
</Target>
<Target Name="Test">
  <Exec Condition=" '@(TestAssemblies)' != ''"
          Command="Mstest.exe /resultsfile:results.trx @(TestAssemblies ->'/testcontainer:"%(RecursiveDir)%(Filename)%(Extension)"', ' ')"
          ContinueOnError="true" IgnoreExitCode="true" />
</Target>
</Project>
{% endhighlight %}

and then we can execute

{% highlight bash  %}
msbuild /t:Build builder.proj -- building the project
msuilbd /t:Test builder.proj -- running all tests
{% endhighlight %}

References
==========

* <a href="https://msdn.microsoft.com/en-us/library/ms171483.aspx" title="How to: Build Incrementally" target="_blank">How to: Build Incrementally</a>
* <a href="https://msdn.microsoft.com/en-us/library/ms171486.aspx" title="How to: Build Specific Targets in Solutions By Using MSBuild.exe" target="_blank">How to: Build Specific Targets in Solutions By Using MSBuild.exe
</a>
* <a href="https://msdn.microsoft.com/en-us/library/ms171464.aspx" title="How to: Use the Same Target in Multiple Project Files" target="_blank">How to: Use the Same Target in Multiple Project Files</a>
* <a href="https://msdn.microsoft.com/en-us/library/92x05xfs.aspx" title="Import Element (MSBuild)" target="_blank">Import Element (MSBuild)</a>
