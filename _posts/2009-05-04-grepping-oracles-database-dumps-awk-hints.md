---
layout: post
title: Grepping Oracle's database dumps = awk hints.
date: 2009-05-04 01:18:09.000000000 +00:00
categories:
- Linux
tags:
- awk
- database
- dump
- grep
- oracle
- tips
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  _sexybookmarks_shortUrl: http://b2l.me/anjyrz
  _sexybookmarks_permaHash: 4e86161dd6bdee75ff32b141e80ae215
author:
  login: radek.antoniuk@gmail.com
  email: radek.antoniuk@gmail.com
  display_name: warden
  first_name: r
  last_name: a
excerpt: !ruby/object:Hpricot::Doc
  options: {}
---
<p>I've just got a database dump from Oracle and I wanted to load it into mysql database. It turned out that it has a lot of Oracle specific things, so I decided to play a little with grep and awk to get the things I want.<br />
<!--more--><br />
Let's suppose that we have a database dump:</p>
<pre colla="+">
CREATE TABLE test1 (
  COL1 INTEGER NOT NULL,
  COL2 INTEGER NOT NULL,
  LAST_UPDATED_ON TIMESTAMP,
  LAST_UPDATED_BY CHAR(8))

INSERT INTO test1 VALUES (d,f)
INSERT INTO test1 VALUES (a,b)
INSERT INTO test1 VALUES (a,b)

CREATE TABLE test2 (
  COL44 INTEGER NOT NULL,
  COL55 INTEGER NOT NULL,
  LAST_UPDATED_ON TIMESTAMP,
  LAST_UPDATED_BY CHAR(8))</pre>
<p>which is a typical structure from mysqldump or other databases.</p>
<ul>
<li>to get all table names from that dump:</li>
</ul>
<pre colla="+"> grep "CREATE TABLE " dump.sql  | cut -d" " -f3 | sort</pre>
<p>Result:</p>
<pre colla="+"> 
test1
test2</pre>
<ul>
<li>to get all table structures from that file:</li>
</ul>
<pre colla="+"> awk 'BEGIN { RS="\n\n"; FS="\n"; PATTERN="CREATE TABLE" } { if ( $0 ~ PATTERN ) print $0; }' dump.sql</pre>
<p>Result:</p>
<pre colla="+">CREATE TABLE test1 (
  COL1 INTEGER NOT NULL,
  COL2 INTEGER NOT NULL,
  LAST_UPDATED_ON TIMESTAMP,
  LAST_UPDATED_BY CHAR(8))
CREATE TABLE test2 (
  COL44 INTEGER NOT NULL,
  COL55 INTEGER NOT NULL,
  LAST_UPDATED_ON TIMESTAMP,
  LAST_UPDATED_BY CHAR(8))</pre>
