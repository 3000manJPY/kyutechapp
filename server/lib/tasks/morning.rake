require 'rake'
require 'twitter'
require 'bitly'

namespace :morning do
task :kit_i => :environment do
    
$dev_consumer_key        = "rsqTgbvIJ5kCTANwemWzAgaU5"
$dev_consumer_secret     = "N9aXGU6hspqh9GricBkQ1kmSntDkZGaw7kt7OEO4WHSfvVgzXN"
$dev_access_token        = "3233383531-xDU0JaM57IqsNZOH2lJMSYSpvbpgHqQruYkn77v"
$dev_access_token_secret = "74A8wnFsPe4AtFWVhOLI0NYbav9w4wD7fmAoA4OFSycYl"

$consumer_key        = "AeJwlsIbN5Zm1FCLZmefICLI2"
$consumer_secret     = "ISXrmbKEPWJNPz6bADjFvJ0wIdcTLBPlWS3Jt4oZnrwRFPMLTh"
$access_token        = "3230971351-JpNKzUYSjnY1JAmE0F43YNUulKnd0v4rd6uzaR9"
$access_token_secret = "rPwoDg2gGqceBnEN3J52FzipOv6AtAHDX58zvlKMuq9fT"

notice_url = {"お知らせ" => "357",
    "奨学金" => "367",
    "補講通知" => "363",
    "休講通知" => "361",
    "授業調整" => "364",
    "学生呼出" => "393",
    "時間割変更" => "391",
    "各種手続き" => "373",
    "集中講義" => "379",
    "留学支援" => "372",
    "学部生情報" => "368",
    "大学院生情報" => "370"}

# 学部名配列
$department_name = [ ["全て","全体"],
["学部","学部全体","学部学生"],
["大学院","大学院全体","大学院学生"],
["知能情報","知能","知能情報工学科"],
["電子情報","電子","電子情報工学科"],
["システム創成","システム","システム創成情報工学科","シス創成"],
["機械情報","機械","機械情報工学科"],
["生命情報","生命","生命情報工学科"]]


def get_twitter_client
 client = Twitter::REST::Client.new do |config|
      config.consumer_key        =  $consumer_key
      config.consumer_secret     =  $consumer_secret
      config.access_token        =  $access_token
      config.access_token_secret =  $access_token_secret
  end
 client
 end

def update(client, tweet)
 begin
   tweet = (tweet.length > 140) ? tweet[0..139].to_s : tweet
   client.update(tweet.chomp)
 rescue => e
   Rails.logger.error "<<twitter.rake::tweet.update ERROR : #{e.message}>>"
 end
end

def bitly_shorten(url)
  Bitly.use_api_version_3
  Bitly.configure do |config|
    config.api_version = 3
    config.access_token = "39e78a5abe2df6d401530cf6192b64d9dac8ba95"
  end
  Bitly.client.shorten(url).short_url
end

categorys = notice_url.to_a


@notices = Notice.where(date: (Time.now.midnight - 1.day)..Time.now.midnight)
@notices.each do |notice|
department = notice.department_id
    if department == 99 
        department = 0
    end
     tweet_msg = "【今日のお知らせ】【" + categorys[notice.category_id][0] + "】" + notice.title + " " + bitly_shorten(notice.web_url) + "  #kit_i" + categorys[notice.category_id][0] + " #kit_i" + $department_name[department][0] 
    client = get_twitter_client

    update(client, tweet_msg)

end

end
end
