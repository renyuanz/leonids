---
layout: post
title: "Customizing Your iTerm2"
excerpt: "Just about everything you'll need to customize your iTerm2 or the default Mac OS X Terminal."
categories: MAC
tags: [terminal, iTerm2, OS X]
date: 2015-04-29T21:32:27+02:00
comments: true
---
Since we're going to be spending a lot of time in the command-line, let's install a better terminal than the default one.

#### Are you looking for something like this?

![Preview]({{ site.url }}/img/preview.png)

#### iTerm2

Download and install iTerm2 (the newest version, even if it says "beta release").

In **Finder**, drag and drop the **iTerm** Application file into the **Applications** folder.

You can now launch iTerm, through the **Launchpad** for instance.

Let's just quickly change some preferences. In **iTerm > Preferences...**, under the tab **General**, uncheck **Confirm closing multiple sessions** and **Confirm "Quit iTerm2 (Cmd+Q)" command** under the section **Closing**.

In the tab **Profiles**, create a new one with the "+" icon, and rename it to your first name for example. Then, select **Other Actions... > Set as Default**. Finally, under the section **Window**, change the size to something better, like **Columns: 125** and **Rows: 35**.

When done, hit the red "X" in the upper left (saving is automatic in OS X preference panes). Close the window and open a new one to see the size change.

#### Beautiful terminal

Throughout a normal day, you'll see your prompt thousands of times. Customizing it with relevant information can drastically improve your workflow.

Let's go ahead and start by changing the font. In **iTerm > Preferences...**, under the tab **Profiles**, section **Text**, change both fonts to **Source Code Pro 13pt**. This font isn't included in the default Mac font libary, so you have to download and install it.

Now let's add some color. I'm a big fan of the **Dracula** color scheme. I just find it pretty. There are so many alternatives such as **solarized**, you can choose whatever you want.

[Download ZIP file](https://github.com/zenorocha/dracula-theme) from github repo. Unzip the archive. In it you will find the **iterm** folder, but I will just walk you through it here:

In **iTerm2 Preferences**, under **Profiles** and **Colors**, go to **Load Presets... > Import...**, find and open the two **.itermcolors** files we downloaded.
Go back to **Load Presets...** and select **Dracula** to activate it. Voila!

Till now, we have finished the appearance of our iTerm2. Next step, we need to tweak a little bit our Unix user's profile. This is done (on OS X and Linux), in the `~/.bash_profile` text file (`~` stands for the user's home directory).

We'll come back to the details of that later, but for now, just download the files [.bash_profile](https://raw.githubusercontent.com/nicolashery/mac-dev-setup/master/.bash_profile), [.bash_prompt](https://raw.githubusercontent.com/nicolashery/mac-dev-setup/master/.bash_prompt), [.aliases](https://raw.githubusercontent.com/nicolashery/mac-dev-setup/master/.aliases) into your home directory:

~~~ bash
$ cd ~
$ curl -O https://raw.githubusercontent.com/nicolashery/mac-dev-setup/master/.bash_profile
$ curl -O https://raw.githubusercontent.com/nicolashery/mac-dev-setup/master/.bash_prompt
$ curl -O https://raw.githubusercontent.com/nicolashery/mac-dev-setup/master/.aliases
~~~

With that, open a new terminal tab (Cmd+T) and see the change! Try the list commands: `ls`, `ls -lh` (aliased to `ll`), `ls -lha` (aliased to `la`).

At this point you can also change your computer's name, which shows up in this terminal prompt. If you want to do so, go to **System Preferences > Sharing**. For example, I changed mine from "Renyuan's MacBook Pro" to just "big-house", so it shows up as "big-house" in the terminal.

Now we have a terminal we can work with!

(Thanks to Nicolas Hery for his [setup document](https://github.com/nicolashery/mac-dev-setup))
