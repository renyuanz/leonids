---
layout: page
title: Theme Setup
permalink: /theme-setup/
comments: true
---
### Get started

1. [Fork the repository](https://github.com/renyuanz/leonids/fork).
2. Clone the repository to your computer `git clone https://github.com/yourname/leonids`.
3. Run `jekyll server` under your leonids project.
4. Go to `http://localhost:4000` for your site.

**Pro-tip:**

Delete the `gh-pages` branch after cloning and start fresh by branching off `master`. There is a bunch of garbage in `gh-pages` used for the theme's demo site that I'm guessing you won't want.

---

### Make it yours

A quick checklist of the files you'll want to edit to get up and running.

#### 1. Site Wide Configuration

`_config.yml` is your friend. Open it up and personalize it. Most variables are self explanatory but here's an explanation of each if needed:

##### Title

The title of your site... shocker!

Example `title: My Awesome Site`

##### Url

Used to generate absolute urls in `sitemap.xml`, `feed.xml`, and for generating canonical URLs in `<head>`. When developing locally either comment this out or use something like `http://localhost:4000` so all assets load properly. **Don't include** a trailing `/`.

Examples:

{% highlight yaml %}
# when you are setting up a gh-pages
url: http://renyuanz.github.io/leonids

# when you are developing locally
url: http://localhost:4000

# and you can leave it blank for developing
url:
{% endhighlight %}


#### 2. New Post

Just create a markdown file named something like: `year-month-day-your-post-title.md` in the directory `_posts`, and here you go.

##### Options

When writing a post, there are serval options you can add to the header.

Example:

{% highlight yaml %}
# these two options are obligable for each post.
layout: post
title: "Post with Large Feature Image and Text"

# the rest is optional.
excerpt: "Custom written post descriptions are the way to go... if you're not lazy." # without setting this option, jekyll will take the first 160 words to be its  excerpt part.
tags: [sample post, readability, test] # tags.
categories: [travel] # categories.
comments: true # enable disqus comment
image:
  feature: sample-image-1.jpg # add a cover image
  credit: Greg Rakozy
  creditlink: https://unsplash.com/photos/oMpAz-DN-9I
{% endhighlight %}

**Pro-tip:**

1. If `comments` is set to `true`, at the end of the post there will be a disqus thread, just like this one. To use disqus, you **MUST** [set up your own disqus account](https://disqus.com).
2. I suggest you to set only one category for a post.

#### 3. New Page

You can create a page by adding directly a markdown file or html file under the root path or a directory with a index page inside. You can check [this page](http://jekyllrb.com/docs/pages/) for more details.

---

### Layouts and Content

Explanations of the various `_layouts` included with the theme and when to use them.

#### Post and Page

These two layouts are very similar. Both have a header navigation and optional Disqus comments. The only real difference is the post layout includes cover image if you've set up.

#### Post Index Page

A [sample index page]({{ site.url }}/) listing all posts ordered by the date they were published has been provided. The name can be customized to your liking by editing a few references.

---

### Social Sharing Links

Social sharing links for Twitter, Facebook, Google+, Hacker News and Reddit are included on posts by default. If you'd like to use different social networks modify `_includes/social-links.html` to your liking. Icons are set using [Font Awesome](http://fontawesome.io).

---

### Further Customization

Jekyll 2.x added support for Sass files making it much easier to modify a theme's fonts and colors. By editing values found in `_sass/variables.scss` you can fine tune the site's colors and `_sass/typography.scss` for the site's typography.

For example if you wanted a red background instead of white you'd change `$text-color: #444;` to `$text-color: $cc0033;`.

---

### The end

Like it? [Tell me @renyuanz](http://twitter.com/alittlered3).

Problem? [Use GitHub Issues](https://github.com/renyuanz/leonids/issues/new).

And if you make something cool with this theme feel free to let me know.

---

### License

This theme is free and open source software, distributed under the MIT License. So feel free to use this Jekyll theme on your site without linking back to me or including a disclaimer.
