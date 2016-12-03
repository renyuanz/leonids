---
layout: post
title: datePicker and jqModal z-index problem
date: 2009-05-18 16:32:09.000000000 +00:00
categories:
- Zend 
- PHP
tags:
- jQuery
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  _sexybookmarks_shortUrl: http://b2l.me/ann3cw
  _sexybookmarks_permaHash: 8ed276cf9d4e439190be8be8030e352b
author:
  login: radek.antoniuk@gmail.com
  email: radek.antoniuk@gmail.com
  display_name: warden
  first_name: r
  last_name: a
excerpt: !ruby/object:Hpricot::Doc
  options: {}
---
<p>It appears that jqModal and datePicker have z-index problems. My datepicker appeared below the form inside jqModal. The fix for this is very simple. We have to modify CSS for UI and jqmodal.<br />
This is because they don't set z-index property properly. But we can change it on our own...<br />
<!--more--></p>
<p>Inside your jqModal class (i.e. jqWindow or something equivalent) add:</p>
<pre colla="+">
z-index: 200;
</pre>
<p>for example:</p>
<pre colla="+">
div.jqmAlert { /* contains + positions the alert window */
  display: none;
  z-index: 200;
  position: fixed;
  top: 7%;
  width: 100%;
}
</pre>
<p>and then in the jQuery UI CSS change the line:</p>
<pre colla="+">
.ui-datepicker { width: 17em; padding: .2em .2em 0;  }
</pre>
<p>to</p>
<pre colla="+">
.ui-datepicker { width: 17em; padding: .2em .2em 0; z-index: 10000; }
</pre>
<p>Now it should work, at least for me it did. If it doesn't, fiddle with z-index properties using FireBug.<br />
Good luck!</p>
