---
layout: post
title: 'Yii:: Avoid to include jquery twice in AJAX rendered actions'
date: 2012-05-25 16:23:47.000000000 +00:00
categories:
- Software Development
tags:
- yii
- php
---
An idea to solve that is to use ClientScript and disable the scripts that you want to avoid.
To do that automatically and globally, you can  use a custom controller like this:
{% highlight bash %}
# components/MyController.php 
<?php
abstract class MyController extends CController {
	public function beforeAction(){
		if( Yii::app()-&gt;request-&gt;isAjaxRequest ) {
			Yii::app()-&gt;clientScript-&gt;scriptMap['jquery.js'] = false;
			Yii::app()-&gt;clientScript-&gt;scriptMap['jquery-ui.min.js'] = false;
		}
		return true;
	}
}
{% endhighlight %}
