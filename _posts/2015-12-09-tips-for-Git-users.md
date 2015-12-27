---
layout: post
title: Tips for Git users
excerpt: "Git is a powerful tool for Web development, here is some useful tips for Git beginners."
categories: Git
comments: true
---

If you know nothing about Git, google it, this is not the right place to start learning Git. I wrote this article for developers who know already the basic Git usage and use Git as an important piece of workflow.

### Always use `git status`

It's good to start off using git with good habits. Using `git status` to find where you are is one of them. The terminal's output shows the actions you can do with the current status.

### I want see a list of details of my last N commits

For example: to see your last 5 commits

~~~ shell
git log -n 5 --author=Salvador
~~~

If you want a simpler one line solution:

~~~ shell
git log --oneline -n 5 --author=Salvador
~~~

If you like the single line version, try creating an alias for git log like this (this is what I have for zsh)

~~~ shell
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
~~~

Now, I can just use:

~~~ shell
glog -n 5
~~~

And I get a nice output.

Which is colorized, shows the name of the author and also shows the graph and you can still pass in other flags (such as --author) which lets you filter it even more.

[You can see the original answer here.](http://stackoverflow.com/questions/13542213/git-see-a-list-of-comments-of-my-last-n-commits#answer-13542327)

