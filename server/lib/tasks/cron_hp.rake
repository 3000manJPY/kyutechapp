require 'open-uri'
require 'nokogiri'
require 'date'
require 'time'
require 'kyutech_bot'

namespace :cron_hp do

  #データベース用ハッシュ
  category = {"お知らせ"   => 0,
              "時間割・講義室変更" => 6,
              "休講通知"   => 3, 
              "補講通知"   => 2,
              "学生呼出"   => 5,
              "授業調整・期末試験" => 4,
              "各種手続き" => 7,
              "奨学金"     => 1,
              "集中講義"   => 8,
              "留学・語学学習支援" => 9,
              "学部生情報" => 10,
              "大学院生情報" => 11,
              "重要なお知らせ" => 12,
              "EVENT"      => 13,
              "TOPICS"     => 14,
              "PRESS SCRAP"=> 15,
              "WHAT'S NEW" => 16,
              "全て"       => 99
              }

  department = {"全て"     => 0,
                "学部"     => 1,
                "大学院"   => 2,
                "知能情報" => 3,
                "電子情報" => 4,
                "システム" => 5,
                "機械情報" => 6,
                "生命情報" => 7,
                "未分類"   => 99
                }

  campus = {"戸畑" => 0,
            "飯塚" => 1,
            "若松" => 2
            }
  
  task :test => :environment do
    puts category.key(12)
  end

  task :tweet_test => :environment do
    puts Kyutech_bot.tweet_morning("たいとる", "かてごり", "がっか", "http://www.iizuka.kyutech.ac.jp/")
  end
 
  desc "飯塚のHPから情報を取得する"
  task :kit_i_hp => :environment do
    # 飯塚のHPにアクセスし、情報を取得する。

    # 日付
    def get_unixtime(date)
      d = Date.strptime(date,"%Y.%m.%d")
      unixtime = Time.parse(date).to_i   
      return unixtime
    end
    
    url = 'http://www.iizuka.kyutech.ac.jp/'
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read 
    end
    
    doc = Nokogiri::HTML.parse(html,nil,charset)
    # 重要なお知らせ
    puts "重要なお知らせ"
    doc.xpath('//*[@id="news"]/ul[1]/li').each do |node|
      @notice = Notice.new
      @notice.title   = node.xpath('a').inner_text
      @notice.web_url = node.xpath('a').attribute('href').value
      @notice.category_id = 12
      @notice.department_id = 0
      @notice.campus_id = 1
      @notice.regist_time = Time.now.to_i
      begin
        @notice.save
        puts "save succeed"
        Kyutech_bot.tweet_new(@notice.title, category.key(@notice.category_id),
department.key(@notice.department_id), @notice.web_url)
      rescue
        puts "no save"
      end
    end

    # EVENT
    puts "EVENT"
    doc.xpath('//*[@id="news"]/dl/table/tbody/tr').each do |node|
      @notice = Notice.new
      @notice.title   = node.xpath('td[4]/a').inner_text
      @notice.web_url = node.xpath('td[4]/a').attribute('href').value
      date    = node.xpath('td[2]/a').inner_text
      @notice.date = get_unixtime(date)
      @notice.category_id = 13
      @notice.department_id = 0
      @notice.campus_id = 1
      @notice.regist_time = Time.now.to_i
      begin
        @notice.save
        puts "save succeed"
        Kyutech_bot.tweet_new(@notice.title, category.key(@notice.category_id), department.key(@notice.department_id), @notice.web_url)
      rescue
        puts "no save"
      end
    end

    # TOPICS,PRESS SCRAP,WATH'S NEW
    cat_id = 12
    doc.xpath('//*[@id="news"]/ul').each do |cat|
      puts "カテゴリ"
      cat_id += 1
      cat.xpath('table/tbody/tr').each do |node|
        @notice = Notice.new
        @notice.title   = node.xpath('td[4]/a').inner_text
        @notice.web_url = node.xpath('td[4]/a').attribute('href').value
        date    = node.xpath('td[2]/a').inner_text
        @notice.date = get_unixtime(date)
        @notice.category_id = cat_id
        @notice.department_id = 0
        @notice.campus_id = 1
        @notice.regist_time = Time.now.to_i
        begin
          @notice.save
          puts "save succeed"
          Kyutech_bot.tweet_new(@notice.title, category.key(@notice.category_id), department.key(@notice.department_id), @notice.web_url)
        rescue
          puts "no save"
        end
      end
    end
  end  
end
