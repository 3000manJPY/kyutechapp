require 'twitter'
require 'bitly'

namespace :kyutech_bot do
  task :tweet => :environment do 
    begin
    client = get_twitter_client
    update(client, "tweet!!!!!")
    rescue
      puts "error"
    end
    puts "tweet"
  end

  def get_twitter_client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "vaAGgV0zCO9tNbiMJnONU1QEH"
      config.consumer_secret     = "ynq66yBFxInu4I6bF4n0lc3baxaSy6oz9cTLkoECJe048SNh7i"
      config.access_token        = "4069740673-7c07MPjR3rOithmKjeeDmALu47mkOLKVHzR53Iw"
      config.access_token_secret = "eRTeWm2Bw9rWrnJYI83y8vX2nfN2gK2xWvhdUNYSX0jXW" 
    end
    client
  end

  # ツイートする
  def update(client, tweet)
    begin
      tweet = (tweet.length > 140) ? tweet[0..139].to_s : tweet
      client.update(tweet.chomp)
      puts "tweet"
    rescue => e
      Rails.logger.error "<<twitter.rake::tweet.update ERROR : #{e.message}>>"
    end
  end

  # URL短縮
  def bitly_shorten(url)
    Bitly.use_api_version_3
    Bitly.configure do |config|
      config.api_version = 3
      config.access_token = ""
    end
    Bitly.client.shorten(url).short_url
  end

end
