---
layout: post
title:  "Packet Capture with Pyshark and Elasticsearch"
date:   2015-12-18 12:40:37
categories: [Programming]
tags: Elastisearch Python Network 
comments: true
---
Network packet capture and analysis are commonly done with tools like tcpdump, snort, and Wireshark. These tools provide the capability to capture packets live from networks and store the captures in PCAP files for later analysis. A much better way to store packets is to index them in Elasticsearch where you can easily search for packets based on any combination of packet fields.

Pyshark is a module that provides a wrapper API to tshark – the command line version of Wireshark – with which you can build packet capture applications that take advantage of all the Wireshark protocol dissectors. With Pyshark and the Elasticsearch Python client library you can easily create a simple packet capture application in Python that can index packets in Elasticsearch.

<!--more-->

**Contents**
* TOC
{:toc}
