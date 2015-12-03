---
layout: post
title: My first Ruby on Rails project
excerpt: "Everything looks great, but the landing page sucks."
categories: Life
comments: true
---

第一次接触到 Ruby 是为什么我已经不记得了，不，确切的说是知道了 Rails 先于 Ruby
 （当时还不知道Ruby是一门语言）。之后，开始疯狂在 lynda 、 codecademy 和 codeschool 上看有关于 Ruby on Rails
 的视频和教程，去淘宝上买几十块钱一个月的 lynda 会员。但却迟迟不能入门。

之后可能是在知乎或是 Ruby China 上看到了 Michael hartl 的 Tutorial ，买了第三版，跟着教程一步一步敲代码。
也是这本教程让我入门了很多 Web 以及应用开发的知识，让我受益良多。不过之后看到很多人对此书的评价，
我也确实要良心的说一句，一开始学习 Rails 就接触边写应用边写测试会有点复杂，但是会让你明白一个系统的开发流程，
这对我之后的学习也有很大的帮助，可以说这本书帮我真正敲开了 Rails 的大门。

大概学了将近大半年的时间后，我在巴黎找了一家设计公司实习，也敲出了第一个 Rails 的专案。我把 Staging 版本
托管在 heroku 上，一来可以降低客户与我们的沟通成本，二来可以利用免费的 heroku 展示我的作品。如果有人感兴趣，
可以点[这里](https://msushi.herokuapp.com/)。

简单介绍一下这个专案吧，我用到了 devise 做前台的用户系统，一个开源的 Rails e-commerce 框架 shoppe 做后台，
以及 foundation 5 来做响应式布局。这不算是一个成功的专案，它里面还有很多没解决的问题：

- 比如 Shoppe 这个 gem
已经提供了一套 customer 系统，在我用 devise 在前台创建用户的时候，我还不能很好的将这两者联系起来。
- 比如新注册的用户，必须要填写个人信息才能点单、付款，但是这个逻辑我做的很粗糙。

不过我也是第一次深入了解了 gem 的运作原理，我把 'shoppe' fork 到自己的 Github 代码仓库中做了很多自定义的改动来
迎合客户的需求：

- 增加了法语版的翻译
- 优化了使用 roo 实现的通过 Excel 批量上传信息的功能
- 修改了一些数据库栏位，以使得资料和信息更符合法国公司的使用习惯

用一个切实的专案来加强巩固自己的所学非常重要。所以，在结束实习之后，我开始折腾了自己的 Jekyll theme ，
并取名 leonids ，意为“狮子座流星雨”，我就是狮子座的，所以有些自恋在所难免。

如你所见，这个博客就是用的 leonids ，如果你觉得还不错，欢迎来我的[repo](https://github.com/renyuanz/leonids)
 fork 或 download 这个 theme ，如果能给我一个 star 就再好不过啦！

如果有任何问题或建议，可以给我[发邮件](mailto:zourenyuan@gmail.com)或是直接在页面下留言。
