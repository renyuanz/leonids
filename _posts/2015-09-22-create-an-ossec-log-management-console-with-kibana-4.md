---
layout: post
title:  "Create an OSSEC Log Management Console with Kibana 4"
date:   2015-09-22 12:40:37
categories: Tutorials
tags: Elasticsearch Kibana OSSEC 
comments: true
---
<img class="image-left" src="/img/kibana4ossec.png" width="150px"/>It’s been awhile since Kibana 4 was released, so I figured it was about time I updated my OSSEC Log Management Console to use the latest and greatest Kibana. The look and feel of Kibana has changed quite a bit, with a new data discovery mode that let’s you browse your data quickly before you create any visualizations. The visualization panels are fluidly moveable to any position, query results are displayed very rapidly and you can even embed your dashboards into static web pages with the dashboard export feature.

In this article I’ll go over how to create a security event dashboard with KIbana 4. I’ll forgo discussing the details on setting up Elasticsearch and Logstash since they have been covered in my previous OSSEC log management and logstash blogs. Read those first to get an idea of how the system described here parses OSSEC alert logs and indexes them with Elasticsearch.

<!--more-->

### Install and Configure Kibana

#### Upgrade to Elasticsearch >= 1.4.4

Kibana 4.x requires at least Elasticsearch 1.4.4, so you must upgrade to at least that version to use Kibana 4. To upgrade your Elasticsearch to 1.4.4 or later go to the Elasticsearch Downloads page then get the latest Elasticsearch package you need for your cluster’s operating system. I use CentOS 6.6 so I get the RPM packages. Then follow the rolling upgrade procedure described on the Upgrading page.

#### Installing Kibana 4

Next you want to go back to the Elasticsearch Downloads page and get Kibana 4.x. Kibana 4 has a Node.js server built in. To get it to work with your cluster you just have to set the first three configuration variables in the *conf/kibana.yml* file:

{% highlight ruby %}
# Set port to the Kibana listening port - default is 5601
port: 9000
 
# The host to bind the server to, all IP addresses in this case.
host: "10.0.0.1"
 
# The Elasticsearch instance to use for all your queries - default is localhost:9200
elasticsearch_url: "http://10.0.0.1:9200"
{% endhighlight %}

There are many other settings that are important, including security settings, but for this article I want to focus on dashboard creation.

To start Kibana just go to the bin directory of your where you installed Kibana and run *kibana*. The built in Node.js server will load all your Kibana stuff so you are ready to go to the console.

#### Set the Index Pattern

The next step involves connecting Kibana to your Elasticsearch data so queries can be performed. Navigate to you Kibana console in the browser. For the example in this article The URL should be `http://10.0.0.1:9000`. With the browser open to the Kibana console, click on the **Settings** tab. You will a screen that looks like the following:
