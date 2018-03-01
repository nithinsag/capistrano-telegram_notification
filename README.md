Capistrano - Telegram Notification
===============================

Notify Capistrano ver3 deployment to Telegram, forked from the slack version by linyows


Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-telegram_notification'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install capistrano-telegram_notification
```

Usage
-----

### Capfile

```ruby
require 'capistrano/telegram_notification'
```

### config/deploy.rb

if use webhook

```ruby
set :telegram_bot_token, '4223:dfsdaf..'
set :telegram_chat_id, '-4234123'

after 'deploy:started', 'telegram:deploy:start'
after 'deploy:finishing', 'telegram:deploy:finish'
after 'deploy:finishing_rollback', 'telegram:deploy:rollback'



License
-------

The MIT License (MIT)
