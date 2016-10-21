---
layout: post
title:  "Create Elasticsearch Snapshots"
date:   2014-12-06 12:40:37
categories: Tutorials
tags: Elasticsearch 
comments: true
---
<img class="image-left" src="/img/Elasticsearch-snapshots.png" width="150px"/>Benjamin Franklin once wrote “…in this world nothing can be said to be certain, except death and taxes”. In this computerized world of ours, I would add having to backup your data to free up disk space to that list of eventualities.

For Elasticsearch users, backups are done using the Elasticsearch snapshot facility. In this article I’ll go through the design of an Elasticsearch backup system that you can use to create snapshots of your cluster’s indices and documents.