require 'rake'
require 'twitter'
require 'bitly'

namespace :crone do

    task :kit_i => :environment do
# トップページから各掲示板へ移動
# 各掲示板から詳細ページへ移動
# 詳細ページからデータをゲット
# record番号を元にかぶらないように分類する
# ゲットした情報をデータベースに追加する

require 'mechanize'
require 'date'

$dev_consumer_key        = "rsqTgbvIJ5kCTANwemWzAgaU5"
$dev_consumer_secret     = "N9aXGU6hspqh9GricBkQ1kmSntDkZGaw7kt7OEO4WHSfvVgzXN"
$dev_access_token        = "3233383531-xDU0JaM57IqsNZOH2lJMSYSpvbpgHqQruYkn77v"
$dev_access_token_secret = "74A8wnFsPe4AtFWVhOLI0NYbav9w4wD7fmAoA4OFSycYl"

$consumer_key        = "AeJwlsIbN5Zm1FCLZmefICLI2"
$consumer_secret     = "ISXrmbKEPWJNPz6bADjFvJ0wIdcTLBPlWS3Jt4oZnrwRFPMLTh"
$access_token        = "3230971351-JpNKzUYSjnY1JAmE0F43YNUulKnd0v4rd6uzaR9"
$access_token_secret = "rPwoDg2gGqceBnEN3J52FzipOv6AtAHDX58zvlKMuq9fT"


url = 'https://db.jimu.kyutech.ac.jp/cgi-bin/cbdb/db.cgi?page=DBView&did='    # 共通部分のURL
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
# divがあるかどうか
notice_div = {"お知らせ"      => 1,
    "奨学金"       => 0,
    "補講通知"     => 0,
    "休講通知"     => 0,
    "授業調整"     => 1,
    "学生呼出"     => 1,
    "時間割変更"   => 1,
    "各種手続き"   => 0,
    "集中講義"     => 0,
    "留学支援"     => 0,
    "学部生情報"   => 0,
    "大学院生情報" => 0}

# 学部名配列
$department_name = [ ["全て","全体"],
["学部","学部全体","学部学生"],
["大学院","大学院全体","大学院学生"],
["知能情報","知能","知能情報工学科"],
["電子情報","電子","電子情報工学科"],
["システム創成","システム","システム創成情報工学科","シス創成"],
["機械情報","機械","機械情報工学科"],
["生命情報","生命","生命情報工学科"]]

# CSSパスの値
$css_record = "td.record-value-"  # グローバル変数
# title_record = ["7", "116"]
# detail_record = ["121","10","11","12","131","129"]
# department_record = ["109","6"]
# date_record = ["4"]
# period_record = ["221","200","94"]
# grade_record = ["111","109","119"]
# place_record = ["6","113"]
subject_record = ["203"]
# teacher_record = ["204","8"]
before_record = ["205"]
after_record = ["206"]
# note_record = ["6","201"]
# document1_record = ["109","117","169"]
# document2_record = ["110","114","120","170"]
# document3_record = ["111","150","171","188"]
# document4_record = ["112","151","172","189"]
# document5_record = ["113","152","173","190"]

# record番号選択メソッド
def title_record(key)
    if key == "時間割変更" then
        return ["116"]
    else
        return ["7"]
    end
end

def detail_record(key)
    if key == "学生呼出" then
        return ["121","11","12"]
    elsif key == "各種手続き" then
        return ["10","11"]
    elsif key == "集中講義" then
        return ["11","10"]
    elsif key == "学部生情報" then
        return ["11","131"]
    elsif key == "大学院生情報" then
        return ["11","129"]
    else
        return ["11"]
    end
end

def department_record(key)
    if key == "時間割変更" then
        return ["6"]
    else
        return ["109"]
    end
end

def period_record(key)
    if key == "お知らせ" then
        return ["221"]
    elsif key == "時間割変更"
        return ["200"]
    else
        return ["94"]
    end
end

def grade_record(key)
    if (key == "お知らせ") || (key == "授業調整") then
        return ["111"]
    elsif (key == "時間割変更") || (key == "休講通知") || (key == "補講通知") then
        return ["109"]
    else
        return ["119"]
    end
end

def place_record(key)
    if (key == "お知らせ") || (key == "各種手続き") then
        return ["6"]
    elsif (key == "補講通知") || (key == "授業調整") || (key == "留学支援") then
        return ["113"]
    else
        return ["9"]
    end
end

def teacher_record(key)
    if (key == "時間割変更") then
        return ["204"]
    else
        return ["8"]
    end
end

def note_record(key)
    if (key == "奨学金") then
        return ["6"]
    else
        return ["201"]
    end
end

def document1_record(key)
    if (key == "各種手続き") || (key == "奨学金") || (key == "集中講義") || (key == "留学支援") || (key == "学部生情報") || (key == "大学院生情報") then
        return  ["109"]
    elsif key == "お知らせ" then
        return ["117"]
    else
        return ["169"]
    end
end

def document2_record(key)
    if key == "お知らせ" then
        return ["120"]
    elsif key =="授業調整" then
        return ["170"]
    elsif key == "奨学金" then
        return ["114"]
    else
        return ["110"]
    end
end

def document3_record(key)
    if (key == "各種手続き") || (key == "留学支援") || (key == "学部生情報") || (key == "大学院生情報") then
        return ["111"]
    elsif key == "お知らせ" then
        return ["188"]
    elsif key == "授業調整" then
        return ["171"]
    else
        return ["150"]
    end
end

def document4_record(key)
    if key == "お知らせ" then
        return ["189"]
    elsif key == "授業調整" then
        return ["172"]
    elsif key == "集中講義" then
        return ["151"]
    else
        return ["112"]
    end
end

def document5_record(key)
    if (key == "学部生情報") || (key == "大学院生情報") then
        return ["113"]
    elsif key == "お知らせ"
        return ["190"]
    elsif key == "授業調整"
        return ["173"]
    else
        return ["152"]
    end
end


# 文字列取得メソッド
def get_varchar(page,record)
    text = ""
    record.each do |rec|
        doc = page.search($css_record + rec).inner_text
        text << doc
    end
    return text
end

# 詳細取得メソッド
def get_detail(page,record)
    text = ""
    record.each do |rec|
        doc = page.search($css_record + rec).inner_text
        if !doc.empty? then
            if doc.length != 0 then
                text << "\n"
            end
            text <<  doc
        end
    end
    return text
end

# 学部ID取得メソッド
def get_departmentID(page,record,key)
    depID = Array.new

# 掲示板によって、学科IDを決定
if (key == "各種手続き") || (key == "奨学金") || (key == "集中講義") || (key == "留学支援") then
    depID.push(0)
elsif key == "学部生情報" then
    depID.push(1)
elsif key == "大学院生情報" then
    depID.push(2)
else
# 文字列から対象学科を捜索。そこからIDを決定
# 対象学部の文字列を取得
text = ""
record.each do |rec|
    doc = page.search($css_record + rec).inner_text
    text << doc
end
# 対象学部の文字列を比較 IDを取得する
$department_name.each_with_index do |dep,i|
    dep.each do |name|
        if text.include?(name) then
            depID.push(i)
            break
        end
    end
end
# 対象学部の文字列が無ければ、未分類
if depID.length <= 0 then
    depID.push(99)
end
end
return depID
end

# 日付取得メソッド
def get_date(page,key)
# 日付の文字列を取得
text = page.search($css_record + "4").inner_text

if key == "集中講義" then
    text.sub('平成','H')
    text.sub('昭和','S')
    text.sub('年','.')
    text.sub('月','.')
    text.sub('日','')
    date = Date.parse(text)
elsif (key == "学部生情報") || (key == "大学院生情報") then
# 日付がない
date = nil
else
    date = Date.strptime(text,'%Y年%m月%d日')
end

unless date.blank?
    unixtime = Time.parse(date.to_s).to_i
end

return unixtime
end

# 添付資料のURLを取得
def get_href(page)
    urls = Array.new
    url = 'https://db.jimu.kyutech.ac.jp/cgi-bin/cbdb/'
    page.search('/html/body/div[3]/table//tr/td[2]/a').each do |doc|
        urls.push(url + doc["href"])
    end
    return urls
end

def get_twitter_client
 client = Twitter::REST::Client.new do |config|
      config.consumer_key        =  $dev_consumer_key
      config.consumer_secret     =  $dev_consumer_secret
      config.access_token        =  $dev_access_token
      config.access_token_secret =  $dev_access_token_secret
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

# URL短縮
def bitly_shorten(url)
  Bitly.use_api_version_3
  Bitly.configure do |config|
    config.api_version = 3
    config.access_token = "39e78a5abe2df6d401530cf6192b64d9dac8ba95"
  end
  Bitly.client.shorten(url).short_url
end

#
## スクレイピングmain ##
agent = Mechanize.new

# 全ての基礎となるURL
url = 'https://db.jimu.kyutech.ac.jp/cgi-bin/cbdb/db.cgi?page=DBView&did='

# div付詳細ページへのXPATH
detail_xpath_div = '/html/body/div[3]/table//tr/td/table[3]//tr[2]/td/table//tr/td[1]/table//tr/td/a'
# div無詳細ページへのXPATH
detail_xpath = '/html/body/table//tr/td/table[3]//tr[2]/td/table//tr/td[1]/table//tr/td/a'

# 各掲示板を回る


new_array = []

notice_url.each_with_index do |(key, value), inx|
    page = agent.get(url + value)
    puts key

    # 詳細ページへのXPATHを選択
    if notice_div[key] == 1 then
        detail_href = detail_xpath_div
    else
        detail_href = detail_xpath
    end

    # 一覧から、詳細ページへのURLを探す
    # tbodyがあると検索できないっぽいので外す
    page.search(detail_href).each do |detail_url|
        detail_page = page.link_with(:href => detail_url[:href]).click    # 詳細ページへのリンクをクリック。リンク先のpage情報ゲット
        @notice = Notice.new
#puts(inx)

        # 各情報をゲット
        @notice.title = get_varchar(detail_page,title_record(key))
        @notice.details = get_detail(detail_page,detail_record(key))
        @notice.category_id = inx
        @notice.department_id = get_departmentID(detail_page,department_record(key),key)[0]
        @notice.campus_id = 1
        @notice.date = get_date(detail_page,key)
        @notice.period_time = get_varchar(detail_page,period_record(key))
        @notice.grade = get_varchar(detail_page,grade_record(key))
        @notice.place = get_varchar(detail_page,place_record(key))
        @notice.subject = get_varchar(detail_page,subject_record)
        @notice.teacher = get_varchar(detail_page,teacher_record(key))
        @notice.before_data = get_varchar(detail_page,before_record)
        @notice.after_data = get_varchar(detail_page,after_record)
        @notice.note = get_varchar(detail_page,note_record(key))
        @notice.document1_name = get_varchar(detail_page,document1_record(key))
        @notice.document2_name = get_varchar(detail_page,document2_record(key))
        @notice.document3_name = get_varchar(detail_page,document3_record(key))
        @notice.document4_name = get_varchar(detail_page,document4_record(key))
        @notice.document5_name = get_varchar(detail_page,document5_record(key))
        @notice.regist_time = Time.now.to_i

        array = get_href(detail_page)
        for i in 1..10

            @notice.document1_url = array[i]
        end

        detail_url = detail_page.uri.to_s
        @notice.web_url = detail_url.sub!(/(.*)&Head.*/){$1}

        begin
            @notice.save
	    print "save succeed"

            puts @notice.title
    	    new_array.push(@notice)
        rescue
            print "no save"
	    

        end

        
        puts "---"
    end
end
print "tweet now!! "

categorys = notice_url.to_a

new_array.each do |notice|
    #tweet_msg = "new!!【" + notice.title
    department = notice.department_id
    if department == 99 
        department = 0
    end
     tweet_msg = "new!!【" + categorys[notice.category_id][0] + "】" + notice.title + " " + bitly_shorten(notice.web_url) + "  #kit_i" + categorys[notice.category_id][0] + " #kit_i" + $department_name[department][0] 
#     tweet_msg = "new!!【" + "】" + notice.title + " " + bitly_shorten(notice.web_url) + "  #kit_i" + notice_url[notice.category_id] + " #kit_i" + department_name[notice.department_id] 
#     tweet_msg = "new!!【" + "】" + notice.title + " " + bitly_shorten(notice.web_url) + "  #kit_i" + notice_url[notice.category_id] + " #kit_i" + department_name[notice.department_id] 
#     tweet_msg = "new!!【" + "】" + notice.title + " " + bitly_shorten(notice.web_url) + "  #kit_i" + notice_url[notice.category_id] + " #kit_i" + department_name[notice.department_id] 
     #tweet_msg = "new!!【" + categorys[notice.category_id][0] + "】" + notice.title + " " + bitly_shorten(notice.web_url) 
    client = get_twitter_client

    update(client, tweet_msg)


end

end

end

