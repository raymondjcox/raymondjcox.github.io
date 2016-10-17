---
title: Ember Fastboot
date: 2016-09-28
tags: ember fastboot
published: true
layout: post
---

[FastBoot](https://www.ember-fastboot.com/) allows Ember to be rendered on both a server and browser instead of only a browser. Ember is great after it's downloaded however on first page load downloading and evaling javascript in the browser takes too long. FastBoot is the best of both worlds, you get a fast initial page load and fast interactions after loading.

[ember-fastboot.com](https://www.ember-fastboot.com) has a great tutorial on how to get started, so I'm going to focus on specific issues I ran into when trying to implement FastBoot.

###Setting up the development environment
The development environment was the most frustrating part of working with FastBoot in my opinion. Currently, live reloading doesn't work so any time I wanted to make a change I had to restart the FastBoot server. Also there's no proxy option for `ember fastboot` so you need to add an adapter host.

###Authentication
Authentication with FastBoot isn't too hard, really. The main issue I ran into was realizing that **FastBoot makes API calls too** and consequently it needs auth headers. So, if you're authenticating with a cookie, you need to pull the cookie off of the request to the FastBoot server and then send that along with future requests. The easiest way I found to do this is with an adapter header.

###What to defer
By deafult FastBoot tries to call all of your model hooks and renders the page based on those hooks. So if you have a widget on your page that makes an AJAX call that isn't in a model hook it's not going to get called. There's a function called `deferRendering` that can get around this which I haven't used yet but it's something to be aware of.

###The shoebox
When you're using FastBoot a lot of work is duplicated because the same code is used for both the server and client. For example, when your route makes an API call it happens in both FastBoot and on the client. The solution to this is the shoebox. The shoebox lets fastboot render your model's JSON on index.html and load that into the store from the client. I recommend taking a look at [ember-data-fastboot](https://github.com/cardstack/ember-data-fastboot) and adapting to your needs.
