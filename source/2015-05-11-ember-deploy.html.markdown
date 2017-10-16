---
title: How to setup Ember Deploy
date: 2015-05-11
tags: ember deploy
layout: post
---

Recently I had a problem where I would have to deploy my Rails app to deploy my Ember app. I found that Ember Deploy was the solution. Ember Deploy is awesome, you should be using it if your deployment strategy is suboptimal.

Ember Deploy is the methodology that your assets should go somewhere and your index.html should go somewhere. The assets typically go on S3, and the index needs to be served by your server (due to CORS restrictions) but can go anywhere usually Redis. Ember deploy allows a lot of nifty things like preview URL's, zero downtime and dynamically modifying index.html.

For my setup I decided to use [ember-cli-deploy](https://github.com/ember-cli/ember-cli-deploy) with a Redis and S3 adapter.

```bash
npm i ember-cli-deploy --save-dev
npm i ember-deploy-redis --save-dev
npm i ember-deploy-s3 --save-dev
```

[ember-cli-deploy](https://github.com/ember-cli/ember-cli-deploy) expects `config/deploy.js` to contain deployment settings that look like this

```javascript
module.exports = {
  development: {
    buildEnv: 'development',
    store: {
      type: 'redis', // the default store is 'redis'
      host: 'localhost',
      port: 6379
    },
    assets: {
      type: 's3', // default asset-adapter is 's3'
      gzip: false,
      gzipExtensions: ['js', 'css', 'svg'],
      accessKeyId: '<your-access-key-goes-here>',
      secretAccessKey: process.env['AWS_ACCESS_KEY'],
      bucket: '<your-bucket-name>'
    }
  },

  staging: {
    buildEnv: 'staging',
    store: {
      host: 'staging-redis.example.com',
      port: 6379
    },
    assets: {
      accessKeyId: '<your-access-key-goes-here>',
      secretAccessKey: process.env['AWS_ACCESS_KEY'],
      bucket: '<your-bucket-name>'
    }
  },

   production: {
    store: {
      host: 'production-redis.example.com',
      port: 6379,
      password: '<your-redis-secret>'
    },
    assets: {
      accessKeyId: '<your-access-key-goes-here>',
      secretAccessKey: process.env['AWS_ACCESS_KEY'],
      bucket: '<your-bucket-name>'
    }
  }
};
```

I also specified a `manifestSize` which determines how many revisions Redis will keep. The only other thing I did was make some modifications to my `Brocfile.js` and `config/environment.js` to add the staging environment.

I used [this gem](http://www.github.com/redis/redis-rb.git) for connecting to Redis. After that, I added a route to a controller that reads the contents of the `current` Redis key and sends that revision to the client. It looks something like this

```ruby
class MyController
  class << self
    def redis
      @redis = Redis.new(url: 'redis://staging-redis.example.com');
    end
  end

  def index
    currentKey = redis.get('my-project:current')
    render text: redis.get(currentKey)
  end
end
```

Notice that `my-project:current` is acutally a link to the `<current-revision>` You can do a lot of other neat things here like take in a `revision` param and render that instead, or insert ruby generated content into your `index.html`.

After all of that is setup, the commands are easy:

- `ember deploy:list` Lists all revisions

- `ember deploy` Deploys assets to S3 and index to Redis

- `ember deploy:activate --revision=<revision>` Moves a revision to current
