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
