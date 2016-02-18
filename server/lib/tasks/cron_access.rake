
require 'slack'

Slack.configure do |config|
      config.token = "xoxp-3241757266-3241855216-21904621733-5c5ec47d24"
end

@CACHE_CALENDER_NAME = "busCalenderName"
@CACHE_TIMETABLE_NAME = "busTimeTableName"

namespace :cron_access do
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
                checkUpdate(@CACHE_CALENDER_NAME, node.attribute('href').value)
            end
            doc.xpath('//*[@id="post-6566"]/ul[3]/a').each do |node|
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
            p "1"
            if name != defaultName 
                p "2"
                Rails.cache.write cache, name
                text = "スクールバスがこうしんされたっぽい、やべぇ"
                slackNotif(text)
            end
        else
            p "3"
            Rails.cache.write cache, name 
        end
    end

end
