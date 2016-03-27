require 'slack'

Slack.configure do |config|
      config.token = "xoxp-3241757266-3241855216-21904621733-5c5ec47d24"
end

@CACHE_CALENDER_NAME = "com.planningdev.kyutechapp.busCalenderName"
@CACHE_TIMETABLE_NAME = "com.planningdev.kyutechapp.busTimeTableName"
@CACHE_NISHITETSU_INFO = "com.planningdev.kyutechapp.nishitetsu.info"

namespace :cron_access do
    
    namespace :nishitetsu do
        desc "西鉄のお知らせが更新されたらslackに通知する"
        task :info_notif => :environment do
            nishitetsu_url = "https://jik.nishitetsu.jp/oshirase?f=info"
            charset = nil
            html = open(nishitetsu_url) do |f|
                charset = f.charset
                 f.read
            end
            doc = Nokogiri::HTML.parse(html, nil, charset)

            @dateStr = Rails.cache.read @CACHE_NISHITETSU_INFO
            doc.xpath('//*[@id="main_contents"]/div[2]/dl').each_with_index  do |node,i|

                date = node.xpath('dt').children.first.inner_text
                if i == 0 
                    @newdate = date
                end
                p @dateStr
                p date
                if date == @dateStr
                    break
                end
                #//*[@id="main_contents"]/div[2]/dl[3]/dt
#                if dateStr == node.
                val = node.xpath('dd/a').inner_text
                if val.include?("飯塚") || val.include?("九工大") || val.include?("戸畑") || val.include?("折尾") || val.include?("若松") || val.include?("九州工業")
                   p val 
                    text = "西鉄バスがどこかを改正したみたいだhttps://jik.nishitetsu.jp/oshirase?f=info"
                    slackNotif(text)
                end
            end
            Rails.cache.write @CACHE_NISHITETSU_INFO,@newdate
        end

    end
    namespace :kit_i do
        schoolbus_url = "http://www.iizuka.kyutech.ac.jp/school_bus/"
        desc "飯塚のスクールバスの時刻表pdfが更新されたらslackに通知する"
        task :schoolbus_notif => :environment do

            charset = nil
            html = open(schoolbus_url) do |f|
                charset = f.charset
                 f.read
            end
            doc = Nokogiri::HTML.parse(html, nil, charset)
            doc.xpath('//*[@id="post-6566"]/ul[2]/a').each do |node|
                p node.attribute('href').value
                checkUpdate(@CACHE_CALENDER_NAME, node.attribute('href').value)
            end
            doc.xpath('//*[@id="post-6566"]/ul[3]/a').each do |node|
                p node.attribute('href').value
                checkUpdate(@CACHE_TIMETABLE_NAME, node.attribute('href').value)
            end

       end 
    end

    def slackNotif(text)
        #将来的にはtwitterのbotとかでもお知らせしたい
        Slack.chat_postMessage text: text, username: "kyutechapp bot", channel: "#kyutechapp_bot_test"
    end

    def checkUpdate(cache,name)
        defaultName = Rails.cache.read cache
        if defaultName != nil
            if name != defaultName
                Rails.cache.write cache, name
                text = "スクールバスがこうしんされたっぽい、やべぇ"
                slackNotif(text)
            end
        else
            Rails.cache.write cache, name
        end
    end


end
