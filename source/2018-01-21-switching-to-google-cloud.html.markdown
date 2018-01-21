---

title: Switching to Google Cloud
date: 2018-01-21 03:40 UTC
tags: google cloud
layout: post

---

I decided to take advantage of [Google Cloud free tier](https://cloud.google.com/free/) &amp; switch all of my sites over. I'm mostly happy with the results.

Originally I had planned on putting my content on [Google Cloud storage](https://cloud.google.com/storage/) (which is like [AWS S3](https://aws.amazon.com/s3/)) and then pointing a load balancer at that. This worked well, I setup load balancer listeners for both `https` and `http` and pointed those at the storage bucket I had created. The first thing I had an issue with was that the IPs for the load balancer http and https were different so I had to reserve an IP, assign it to both http and https and then point the A record at that. After this everything worked!

Unfourtantly I could not force the load balancer to redirect `http` traffic to `https`. Therefore I switched my load balancer to point at  a compute instance setup with [Nginx](https://nginx.org/) which is also on the free tier. Here is my config for that:

```
server {
    listen       80;
    server_name  raymondjcox.com www.raymondjcox.com;
    root   /var/www/raymondjcox.com;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    if ($http_x_forwarded_proto = 'http') {
       return 301 https://raymondjcox.com$request_uri;
    }

    if ($host = 'www.raymondjcox.com' ) {
       return 301 https://raymondjcox.com$request_uri;
    }

    location / {
        index  index.html index.htm;
    }

    location ~* \.(?:ico|css|js|gif|jpe?g|png)$ {
        expires 30d; # expires after 30 days
        add_header Cache-Control "public"; # clients can cache
    }
}
```

An important key here is `$http_x_forwarded_proto` which is what something the google load balancer sends to let you know if it's http or https traffic. Also, important to note that [ssl termination](https://en.wikipedia.org/wiki/TLS_termination_proxy) is done at the load balancer level so this can listen on port 80.
