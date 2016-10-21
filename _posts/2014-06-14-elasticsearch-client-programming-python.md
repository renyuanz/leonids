---
layout: post
title:  "Elasticsearch Client Programming - Python"
date:   2014-06-12 12:40:37
categories: Programming
tags: Elasticsearch Python 
comments: true
---
<img class="image-left" src="/img/Elasticsearch-Python.png" width="150px"/>The first article in this two part series focused on developing Elasticsearch clients with Perl. Elasticsearch also has an excellent Python library which lets you search for and analyze your data with one of the many mathematics and machine learning libraries available for Python.

In this article I’ll cover how to create an Elasticsearch client using Python that has the same capabilities as the Perl client from the part 1 article.

<!--more-->

### Got Anaconda Python?

There are many ways to get Python on your system, if you don’t have it already. It usually comes pre-installed on Linux systems. But I’ve developed a fondness for Anaconda Python provided by Continuum Analytics. Anaconda Python comes complete with a large set of libraries, including specialized machine learning modules such as NumPym, SciPy, scikit-image, scikit-learn, etc. Since I work with a machine learning group, I find this aspect of Anaconda Python particularly appealing. You can download Anaconda Python here.

### Install PyDev Plug-in for Eclipse

Even if you are an expert wth Python, I highly recommend writing your first Elasticsearch client using the Eclipse IDE, which has a Python development plug-in that helps you not only step through your code but also see how Elasticsearch JSON is mapped to Python data structures. If you don’t have a Perl environment for Eclipse then follow the steps in this section to install one.

The PyDev project produces a plug-in for Eclipse that provides assistance for Python development. You can install the plug-in by following these steps.

1. Select **Help > Install New Software…** from the Eclipse main menu.
2. Click on **Add** button to add the **Eclipse Perl Integration** update site.
3. Enter `PyDev and PyDev Extensions` in the name field.
   ![](/img/Add-PyDev-and-PyDev-Extensions.png)
4. Enter `hxxp://pydev.org/updates in the location` field.
5. Click on **OK**.
5. Click on the check box next to **PyDev**.
   ![](/img/Available-Software-PyDev.png)
6. Click on the Finish button. Note the button in this illustration is greyed out since I have already installed the PyDev plug-in on my system, but for first installations the

To add the Elasticsearch client library for Python on either Linux, Windows or Mac OS, simply run pip as follows

{% highlight bash %}
pip install Elasticsearch
{% endhighlight %}

### Connecting to Elasticsearch

Let’s say we have an Elasticsearch cluster comprised of indices that contain data collected from Twitter’s 1% sample feed. The tweets are collected in a new index each day.  The format of the index name is `yyyy-mm-dd`. The server nodes that are exposed to clients is 10.1.1.1 and 10.1.1.2 .

Now let’s do some programming. First create a new Perl project and client application file.

1. Select **File > New > Other…**
2. Enter the project name on the *Select Wizard* panel. Let’s call it `myPythonProject`.
3. Select **PyDev > PyDev** Project
4. Click on **Finish**.
5. Right click on the **Python** project in the *Navigation* panel then select **New > Other…**
6. Select **General > File**
7. Enter the file name on the S*elect Wizard* panel.  Let’s call it `tweet_search.py`.
8. Click on **Finish**.
9. Double click on `tweet_search.pl`, then start by entering the following code.