require 'telegram/bot'

namespace :telegram do
  set :telegram_bot_key, nil
  set :telegram_chat_id, nil

  set :telegram_deployer, -> {
        username = `git config --get user.name`.strip
        username = `whoami`.strip unless username
        username
      }

  set :telegram_stage, -> {
        stage = fetch(:stage)
        stage.to_s == 'production' ? ":warning: #{stage}" : stage
      }

  def send_to_telegram(message)
    puts "sending message"
    Telegram::Bot::Client.run(fetch(:telegram_bot_key)) do |bot|
      bot.api.send_message(chat_id: fetch(:telegram_chat_id), text: message)
    end
  end

  def telegram_start
    text = "Started deploying to #{fetch(:telegram_stage)} by #{fetch(:telegram_deployer)}" +
           " (branch #{fetch(:branch)}) at #{Time.now}"
    send_to_telegram(text)
  end

  def telegram_failure
    time = elapsed_time()
    text = "Failed deploying to #{fetch(:telegram_stage)} by #{fetch(:telegram_deployer)}" +
           " (branch #{fetch(:branch)} at #{fetch(:current_revision)} / #{Time.now} )"
    send_to_telegram(text)
  end

  def telegram_success
    task = fetch(:deploying) ? 'deployment' : '*rollback*'
    text = "Successful #{task} to #{fetch(:telegram_stage)} by @#{fetch(:telegram_deployer)}" +
           " (branch #{fetch(:branch)} at #{fetch(:current_revision)} / #{Time.now} )"
    send_to_telegram(text)
  end

  namespace :deploy do
    desc 'Notify a deploy starting to Telegram'
    task :start do
      telegram_start
    end

    desc 'Notify a deploy finish to Telegram'
    task :finish do
      telegram_success
    end

    desc 'Notify a deploy rollback to Telegram'
    task :rollback do
      if (fetch(:deploying))
        telegram_success
      else
        telegram_failure
      end
    end
  end
end
