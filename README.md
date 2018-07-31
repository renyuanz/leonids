# Update 07/09/2018

I'm planning to refactor Leonids theme!!!

The goal is really simple: make documentation more intuitive and deployment simpler!!!

Here is the plan:

| Version | Description | Date |
| --- | --- | --- |
| 1.1 | Jekyll version deployable with gem | 07/15/2018 |
| 1.2 | New features: Pagination, Prev/Next post | 07/22/2018 |
| 2.0 | Gatsby or Vuepress version (vote in Issues) | who knows... |

As the project was and will be designed to improve your writing experience, only documentation, gem, deployment process with CI relevant PRs are acceptable in the future.

I want you to know how much I value your support.

Share it to your timeline!

# Update 05/06/2016

Important! It's better to download the gzipped files instead of forking the repo. I would really appreciate if you could give me a star. 😁

This project is under MIT license, so feel free to make it your own.

# Leonids Jekyll Themes

**[Leonids](http://renyuanz.github.io/leonids)** is a clean Jekyll theme perfect for powering your GitHub hosted blog.

## What is Leonids?

* Responsive templates. Looking good on mobile, tablet, and desktop.
* Simple and clear permalink structure.
* Support for Disqus Comments.
* Support for multi-authors.
* **And** the Leonids (/ˈliːənɪdz/ lee-ə-nidz) are a prolific meteor shower associated with the comet [Tempel-Tuttle](https://en.wikipedia.org/wiki/55P/Tempel%E2%80%93Tuttle).

See a [demo](http://renyuanz.github.io/leonids/) hosted on GitHub.

## Quick setup

```
git clone https://github.com/renyuanz/leonids
cd leonids
jekyll server
```

Check out your awesome blog at `http://localhost:4000` and Cheers!

## Running with Docker

```
docker run --rm -it --volume=$PWD:/srv/jekyll -p 4000:4000 jekyll/jekyll:pages jekyll serve --watch --force_polling
```

## Resume Page by [@Skn0tt](https://github.com/Skn0tt)
Leonids features a simple resume page. It is divided up into five sections:

* Bio (Edit \_data/index/careers.yml)
* Education (Edit \_data/index/education.yml)
* Skills (Edit \_data/index/skills.yml)
* Projects (Edit \_data/index/projects.yml)
* About (Edit \_includes/sections/about.html)

You can put all your info into these files, and they will be featured on the resume page.

## TODO

- [ ] Redesign categories page. Ref: [dribbble: blog category section By Ilja Miskov](https://dribbble.com/shots/2274792-Blog-Category-Selection)
- [ ] Multi languages support.
