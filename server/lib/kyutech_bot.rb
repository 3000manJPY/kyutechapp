require 'twitter'
require 'bitly'

class Kyutech_bot

  @campus = {"戸畑" => 0,
            "飯塚" => 1,
            "若松" => 2
            }

=begin 
  def self.tweet
    begin
    client = get_twitter_client
    update(client, "tweet!!!!!")
    rescue
      puts "error"
    end
  end
=end

  def self.tweet_new(title, category, department, campus_id, web_url)
    text = make_bot(title, category, department, campus_id, web_url)
    puts text
    begin
    client = get_twitter_client(campus_id)
    update(client, "new!!" + text )
    rescue
      puts "tweet error"
    end
  end

  def self.tweet_morning(title, category, department, campus_id, web_url)
    text = make_bot(title, category, department, campus_id, web_url)
    puts text
    begin
    client = get_twitter_client(campus_id)
    update(client, "【今日のお知らせ】" + text )
    rescue
      puts "tweet error"
    end
  end

  def self.make_bot(title, category, department, campus_id, web_url)
    tag = select_hashtag(campus_id);
    short_url = bitly_shorten(web_url)
    text = '【' + category + '】' + title + ' ' + short_url + ' ' + tag + category + ' ' + tag + department
    return text
  end

  def self.select_hashtag(campus_id)
    case campus_id
    when @campus["戸畑"] then
      return '#kit_e'
    when @campus["飯塚"] then
      return '#kit_i'
    when @campus["若松"] then
      return '#kit_b'
    end
  end
  
  def self.get_twitter_client(campus_id)
      if Rails.env.production?
        case campus_id
        when @campus["飯塚"] then
          client = Twitter::REST::Client.new do |config|
           config.consumer_key        = "Q6KCtMS2co7OEmKAPPdB1nvQV"
            config.consumer_secret     = "QbLCPTwA5bxmcnbIV4LhR8amNWvwXn1nIakRKWn6nYlJHVOlAU"
            config.access_token        = "3230971351-O9qWFFZHDlygzEhx9K8V0zYBKroLnKOMXj2mrDP"
           config.access_token_secret = "WUegPowRcn3SVeGKmG7C6wnaM5GGNQFukVrRoPU23wTTw" 
          end
        when @campus["戸畑"] then
          client = Twitter::REST::Client.new do |config|
            config.consumer_key        = "wVVxaX65WGbDwLJxRF6vlvN8b"
            config.consumer_secret     = "Z4ezFzud8CkukKRFUep6ZmySqLnn5aI5i5KbFrov73PxzRKqP5"
            config.access_token        = "4477221013-eRKSpd7R6VgRI4UxvVKavcxNpBcDRVJcacC59iq"
            config.access_token_secret = "gErzSCxRf1X9OLkiogSQRClsQs1DhAR31AWl08zyvvPEM"
         end
        when @campus["若松"] then
          client = Twitter::REST::Client.new do |config|
            config.consumer_key        = "g6HJOAAIG0L1AaWGpWDCLlUN5"
            config.consumer_secret     = "UXNC0lHZEvFSvgf7KMC7L4zBf1GaiFIjm699Ys79gZcGPqVWp7"
            config.access_token        = "4483296253-BsahnjuRX8CrQmnv2pWHEQkiwPSbkpLpj4lOx13"
            config.access_token_secret = "dsN9dsMa0ecJ1EfOaCThBEgqdfMW3IJ9jGnhtBrtRsIXl"
          end
        end
    end
#    client
  end

  # ツイートする
  def self.update(client, tweet)
    begin
      tweet = (tweet.length > 140) ? tweet[0..139].to_s : tweet
      client.update(tweet.chomp)
      puts "tweet"
    rescue => e
      Rails.logger.error "<<twitter.rake::tweet.update ERROR : #{e.message}>>"
    end
  end

  # URL短縮
  def self.bitly_shorten(url)
    Bitly.use_api_version_3
    Bitly.configure do |config|
      config.api_version = 3
      config.access_token = "39e78a5abe2df6d401530cf6192b64d9dac8ba95"
    end
    Bitly.client.shorten(url).short_url
  end

end

