---
layout: post
title: 'QuickTip: Styling jqModal with blockUI and AJAX requests'
date: 2009-05-16 14:03:24.000000000 +00:00
categories: []
tags:
- ajax
- jqmodal
- jQuery
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  _sexybookmarks_shortUrl: http://b2l.me/ann3cg
  _sexybookmarks_permaHash: 0a42ef6053590dcc040e59431965fad6
author:
  login: radek.antoniuk@gmail.com
  email: radek.antoniuk@gmail.com
  display_name: warden
  first_name: r
  last_name: a
excerpt: !ruby/object:Hpricot::Doc
  options: {}
---
This is just a quick tip how to style a jqModal window when we are loading contents via AJAX. There are two possibilites:

use ajaxText, but this sometimes is not handy if you have complex styled content from AJAX
use blockUI and style the jqModal to show only after the AJAX has been loaded.

My idea is to block the user interface with a "Please wait..." message and then to slide down nicely the jqModal and unblock the page.  So, firstly, we add the styles to jqModal dialog:

{% highlight javascript %}

$('.dialog').jqm(
                ajax: '@href',
		modal: true,
		target: '#target',
    	        onShow: function(h){ 
                  $.blockUI({ css: { 
                    border: 'none', 
                    padding: '15px', 
                    backgroundColor: '#000', 
                    '-webkit-border-radius': '10px', 
                    '-moz-border-radius': '10px', 
                    opacity: '.5', 
                    color: '#fff' 
                 } }); 
               },
		onLoad: function(h){
			h.w.css('opacity',0.8).slideDown();
                        $.unblockUI();
		},
		onHide: function(h) {
			h.w.slideUp('slow');
			h.o.remove();
		}
);
{% endhighlight %}

Et Voila, you're done!  Hopefully somebody will find this useful.
