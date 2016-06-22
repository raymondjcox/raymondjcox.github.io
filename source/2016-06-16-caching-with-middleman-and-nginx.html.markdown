---
title: Caching Middleman & Nginx
date: 2016-06-16
tags: caching nginx middleman fingerprint
layout: post
---

I recently setup a blog with Middleman served through Nginx. I always forget the best way to cache assets, so this is a nice reminder for me and anyone interested. In general you want to cache images, javascript, and css in the client users browser for a long time so no request has to be made. In nginx this is pretty simple to do

```
  location ~* \.(?:ico|css|js|gif|jpe?g|png)$ {
    expires 30d; # expires after 30 days
    add_header Cache-Control "public"; # clients can cache
  }
```

With Middleman you need a way to bust the cache, you can do this with fingerprints.

```ruby
  configure :build do
    activate :asset_hash
  end
```

Now to test
`curl https://raymondjcox.com/images/face-d04725c4.png`
returns

```
HTTP/1.1 200 OK
Server: nginx/1.11.1
Date: Thu, 16 Jun 2016 01:33:18 GMT
Content-Type: image/png
Content-Length: 40257
Last-Modified: Thu, 16 Jun 2016 00:58:02 GMT
Connection: keep-alive
ETag: "5761f99a-9d41"
Expires: Sat, 16 Jul 2016 01:33:18 GMT
Cache-Control: max-age=2592000
Cache-Control: public
Accept-Ranges: bytes
```
