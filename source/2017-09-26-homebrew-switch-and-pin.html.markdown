---

title: Homebrew switch &amp; pin
date: 2017-09-26 18:37 UTC
tags: homebrew postgres
layout: post
---

Yesterday I updated and upgraded my [Homebrew](https://brew.sh/) packages

``` bash
$ brew update && brew upgrade
```

It seemed to work fine. The next day I restarted my computer and noticed that Postgres hadn't started. When I tried to start it I got this error message:

``` bash
$ pg_ctl -D /usr/local/var/postgres start
server starting
FATAL:  database files are incompatible with server
DETAIL:  The data directory was initialized by PostgreSQL version 9.5, which is not compatible with this version 9.6.5.
```

What happened? Postgres updated to version `9.6.5` but my database was initialized to `9.5`. Whoops. To list all installed versions of Postgres I used this command:

``` bash
$ brew ls --versions postgresql
postgresql 9.5.5 9.6.1 9.6.2 9.6.3 9.6.4 9.6.5
```

I then switched back to a Postgres version that was already installed (in my case `9.5.5`):

``` bash
$ brew switch postgresql 9.5.5
```

After doing this I did a little research and discovered `brew pin`:

``` bash
$ brew pin postgresql
```
This stops Postgres from updating when I `brew upgrade` so I will never have this problem again (with Postgres).
