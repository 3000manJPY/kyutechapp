require 'rake'
require 'open-uri'
require 'mechanize'
require 'nokogiri'
require 'date'
require 'time'
require 'kyutech_bot'

namespace :cron do

  @tweet_base_url = "https://kyutechapp.planningdev.com/api/v2/notices/redirect/"
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
              "ニュース"   => 13,
              "イベント"   => 14,
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


  desc "飯塚の掲示板から情報を取得する。"
  task :kit_i => :environment do

    #共通部分のURL
    url = 'https://db.jimu.kyutech.ac.jp/cgi-bin/cbdb/db.cgi?page=DBView&did='
    notice_url = {"お知らせ"     => "357",
                  "奨学金"       => "367",
                  "補講通知"     => "363",
                  "休講通知"     => "361",
                  "授業調整"     => "364",
                  "学生呼出"     => "393",
                  "時間割変更"   => "391",
                  "各種手続き"   => "373",
                  "集中講義"     => "379",
                  "留学支援"     => "372",
                  "学部生情報"   => "368",
                  "大学院生情報" => "370"}
    # divがあるかどうか
    notice_div = {"お知らせ"     => 0,
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
    #　正規表現用学部名
    $department_name = {"全て"         => "全",
                        "学部"         => "学部",
                        "大学院"       => "大学院",
                        "知能情報"     => "知能",
                        "電子情報"     => "電子",
                        "システム創成" => "シス",
                        "機械情報"     => "機械",
                        "生命情報"     => "生命",}

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
    # パスがカテゴリによって重なっているため、分類するメソッド
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
      if (key == "各種手続き") || (key == "留学支援") || (key == "学部生情報") ||(key == "大学院生情報") then
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
        text = text.gsub(/平成/,'H')
        text = text.gsub(/昭和/,'S')
        text = text.gsub(/年|月/,'.')
        text = text.gsub(/日/,'')
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
    def get_href(page,div)
      urls = [""]
      url = 'https://db.jimu.kyutech.ac.jp/cgi-bin/cbdb/'
      href_xpath = '/html/body/table//tr/td[2]/a'
      href_xpath_div = '/html/body/div[3]/table//tr/td[2]/a'
      if div == 1 then
        url_xpath = href_xpath_div
      else
        url_xpath = href_xpath
      end
     
      page.search(url_xpath).each do |doc|
        urls.push(url + doc["href"])
      end
      return urls
    end

    # task kit_i スクレイピングメイン文
    agent = Mechanize.new

    # 全ての基礎となるURL
    url = 'https://db.jimu.kyutech.ac.jp/cgi-bin/cbdb/db.cgi?page=DBView&did='

    # div付詳細ページへのXPATH
    detail_xpath_div = '/html/body/div[3]/table//tr/td/table[3]//tr[2]/td/table//tr/td[1]/table//tr/td/a'
    # div無詳細ページへのXPATH
    detail_xpath = '/html/body/table//tr/td/table[3]//tr[2]/td/table//tr/td[1]/table//tr/td/a'

    #各掲示板を回る 
    notice_url.each_with_index do |(key, value), inx|
      page = agent.get(url + value)
      puts key
      # 詳細ページのXPATHを選択
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
        # 各情報をGET
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

        document_url = get_href(detail_page, notice_div[key])
        @notice.document1_url = document_url[1]
        @notice.document2_url = document_url[2]
        @notice.document3_url = document_url[3]
        @notice.document4_url = document_url[4]
        @notice.document5_url = document_url[5]
       
        detail_url = detail_page.uri.to_s
        @notice.web_url = detail_url.sub!(/(.*)&Head.*/){$1}

        begin
            @notice.save
            print "save succeed"
            puts @notice.title
	    @save_obj = Notice.find_by(title: @notice.title, category_id: @notice.category_id, department_id: @notice.department_id, campus_id: @notice.campus_id, web_url: @notice.web_url)
	    @tweet_url = @tweet_base_url + @save_obj.id.to_s
            Kyutech_bot.tweet_new(@notice.title, category.key(@notice.category_id),department.key(@notice.department_id), @notice.campus_id, @tweet_url)
        rescue
            print "no save"
        end
        puts "---"

      end
    end

  end # taks kit_i

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
    charset = nil # 変数charsetにnilを代入 = 初期化かな
    html = open(url) do |f| # 変数htmlにopen文を代入し、UTLにアクセスし、そのURLを開く
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込み、変数htmlに渡すメソッド
    end

    doc = Nokogiri::HTML.parse(html,nil,charset)
    puts "飯塚"
    #重要なお知らせ
    puts "重要なお知らせ"
    doc.xpath('//*[@id="news"]/ul[1]/li').each do |node|
      @notice = Notice.new
      @notice.title   = node.xpath('a').inner_text
      @notice.web_url = node.xpath('a').attribute('href').value
      @notice.category_id = category["重要なお知らせ"]
      @notice.department_id = department["全て"]
      @notice.campus_id = campus["飯塚"]
      @notice.regist_time = Time.now.to_i
      begin
        @notice.save
        puts "save succeed"
	@save_obj = Notice.find_by(title: @notice.title, category_id: @notice.category_id, department_id: @notice.department_id, campus_id: @notice.campus_id, web_url: @notice.web_url)
	@tweet_url = @tweet_base_url + @save_obj.id
        Kyutech_bot.tweet_new(@notice.title, category.key(@notice.category_id), department.key(@notice.department_id), @notice.campus_id, @tweet_url)
      rescue
        puts "no save"
      end
    end

    # EVENT
    puts "イベント"
    doc.xpath('//*[@id="news"]/dl/table/tbody/tr').each do |node|
      @notice = Notice.new
      @notice.title   = node.xpath('td[4]/a').inner_text
      @notice.web_url = node.xpath('td[4]/a').attribute('href').value
      date    = node.xpath('td[2]/a').inner_text
      @notice.date = get_unixtime(date)
      @notice.category_id = category["イベント"]
      @notice.department_id = department["全て"]
      @notice.campus_id = campus["飯塚"]
      @notice.regist_time = Time.now.to_i
      begin
        @notice.save
        puts "save succeed"
	@save_obj = Notice.find_by(title: @notice.title, category_id: @notice.category_id, department_id: @notice.department_id, campus_id: @notice.campus_id, web_url: @notice.web_url)
	@tweet_url = @tweet_base_url + @save_obj.id

        Kyutech_bot.tweet_new(@notice.title, category.key(@notice.category_id), department.key(@notice.department_id), @notice.campus_id, @tweet_url)
      rescue
        puts "no save"
      end
    end

    # TOPICS,PRESS SCRAP,WATH'S NEW
    puts "ニュース"
    doc.xpath('//*[@id="news"]/ul/table/tbody/tr').each do |node|
      @notice = Notice.new
      @notice.title   = node.xpath('td[4]/a').inner_text
      @notice.web_url = node.xpath('td[4]/a').attribute('href').value
      date    = node.xpath('td[2]/a').inner_text
      @notice.date = get_unixtime(date)
      @notice.category_id = category["ニュース"]
      @notice.department_id = department["全て"]
      @notice.campus_id = campus["飯塚"]
      @notice.regist_time = Time.now.to_i
      begin
        @notice.save
        puts "save succeed"
	@save_obj = Notice.find_by(title: @notice.title, category_id: @notice.category_id, department_id: @notice.department_id, campus_id: @notice.campus_id, web_url: @notice.web_url)
	@tweet_url = @tweet_base_url + @save_obj.id

        Kyutech_bot.tweet_new(@notice.title, category.key(@notice.category_id), department.key(@notice.department_id), @notice.campus_id, @tweet_url)
      rescue
        puts "no save"
      end
    end
  end # task kit_i_hp

  desc "戸畑のHPから情報を取得する"
  task :kit_e_hp => :environment do
    # 戸畑のHPにアクセスし、情報を取得する
    
    # 日付取得メソッド
    def get_unixtime(date)
      d = Date.strptime(date,"%Y-%m-%d")
      unixtime = Time.parse(date).to_i
      return unixtime
    end
 
    url = 'http://www.tobata.kyutech.ac.jp/'
    charset = nil # 変数charsetにnilを代入 = 初期化かな
    html = open(url) do |f| # 変数htmlにopen文を代入し、UTLにアクセスし、そのURLを開く
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込み、変数htmlに渡すメソッド
    end

    doc = Nokogiri::HTML.parse(html,nil,charset)
    puts "戸畑"
    # 重要なお知らせ
    puts "重要なお知らせ"
    doc.xpath('//*[@id="content-top"]/div[4]/div/div/div/div[1]/div').each do |node|
      @notice = Notice.new
      @notice.title   = node.xpath('span[3]/a').inner_text
      @notice.web_url = url + node.xpath('span[3]/a').attribute('href').value
      date = node.xpath('span[1]').inner_text.strip!
      @notice.date = get_unixtime(date)
      @notice.category_id = category["重要なお知らせ"]
      @notice.department_id = department["全て"]
      @notice.campus_id = campus["戸畑"]
      @notice.regist_time = Time.now.to_i
      begin
        @notice.save
        puts "save succeed"
        Kyutech_bot.tweet_new(@notice.title, category.key(@notice.category_id), department.key(@notice.department_id), @notice.campus_id, @notice.web_url)
      rescue
        puts "no save"
      end
    end
    
    #EVENT
    puts "イベント"
    doc.xpath('//*[@id="content-top"]/div[5]/div/div/div/div[1]/div').each do |node|
      @notice = Notice.new
      @notice.title   = node.xpath('span[3]/a').inner_text
      @notice.web_url = url + node.xpath('span[3]/a').attribute('href').value
      date    = node.xpath('span[1]/span').inner_text
      @notice.date = get_unixtime(date)
      @notice.category_id = category["イベント"]
      @notice.department_id = department["全て"]
      @notice.campus_id = campus["戸畑"]
      @notice.regist_time = Time.now.to_i
      begin
        @notice.save
        puts "save succeed"
        Kyutech_bot.tweet_new(@notice.title, category.key(@notice.category_id),
      department.key(@notice.department_id), @notice.campus_id, @notice.web_url)
      rescue
        puts "no save"
      end
    end

    #ニュース
    puts "ニュース"
    doc.xpath('//*[@id="content-top"]/div[6]/div/div/div/div[1]/div').each do |node|
      @notice = Notice.new
      @notice.title   = node.xpath('div/a').inner_text
      @notice.web_url = url + node.xpath('div/a').attribute('href').value
      @notice.category_id = category["ニュース"]
      @notice.department_id = department["全て"]
      @notice.campus_id = campus["戸畑"]
      @notice.regist_time = Time.now.to_i
      begin
        @notice.save
        puts "save succeed"
        Kyutech_bot.tweet_new(@notice.title, category.key(@notice.category_id),
      department.key(@notice.department_id), @notice.campus_id, @notice.web_url)
      rescue
        puts "no save"
      end
    end
  end # task kit_e_hp

  desc "若松のHPから情報を取得する"
  task :kit_b_hp => :environment do
    # 若松のHPにアクセスし、情報を取得する
    
    # 日付
    def get_unixtime(date)
      d = Date.strptime(date,"%Y.%m.%d")
      unixtime = Time.parse(date).to_i
      return unixtime
    end

    url = 'http://www.lsse.kyutech.ac.jp/'
    charset = nil # 変数charsetにnilを代入 = 初期化かな
    html = open(url) do |f| # 変数htmlにopen文を代入し、UTLにアクセスし、そのURLを開く
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込み、変数htmlに渡すメソッド
    end

    doc = Nokogiri::HTML.parse(html,nil,charset)
    #重要なお知らせ
    puts "重要なお知らせ"
    doc.xpath('//*[@id="main"]/div[1]/ul/li').each do |node|
      @notice = Notice.new
      @notice.title   = node.xpath('a').inner_text
      @notice.web_url = node.xpath('a').attribute('href').value
      @notice.category_id = category["重要なお知らせ"]
      @notice.department_id = department["全て"]
      @notice.campus_id = campus["若松"]
      @notice.regist_time = Time.now.to_i
      begin
        @notice.save
        puts "save succeed"
        Kyutech_bot.tweet_new(@notice.title, category.key(@notice.category_id), department.key(@notice.department_id), @notice.campus_id, @notice.web_url)
      rescue
        puts "no save"
      end
    end

    # ニュース
    puts "ニュース"
    doc.xpath('//*[@id="main"]/div[2]/dl/dd').each_with_index do |node, i|
      @notice = Notice.new
      @notice.title   = node.xpath('a').inner_text
      @notice.web_url = node.xpath('a').attribute('href').value
      num = "#{i+1}"
      path = '//*[@id="main"]/div[2]/dl/dt[' + num + ']'
      date    = doc.xpath(path).inner_text
      @notice.date = get_unixtime(date)
      @notice.category_id = category["ニュース"]
      @notice.department_id = department["全て"]
      @notice.campus_id = campus["若松"]
      @notice.regist_time = Time.now.to_i
      begin
        @notice.save
        puts "save succeed"
        Kyutech_bot.tweet_new(@notice.title, category.key(@notice.category_id),
department.key(@notice.department_id), @notice.campus_id, @notice.web_url)
      rescue
        puts "no save"
      end
    end

    # イベント
    puts "イベント"
    doc.xpath('//*[@id="main"]/div[3]/dl/dt').each_with_index do |node, i|
      @notice = Notice.new
      @notice.title   = node.xpath('a').inner_text
      @notice.web_url = node.xpath('a').attribute('href').value
      puts @notice.title
      puts @notice.web_url
      num = "#{i+1}"
      path = '//*[@id="main"]/div[3]/dl/dd[' + num + ']'
      detail = doc.xpath(path).inner_text
      /\d{4,4}\.\d{1,2}\.\d{1,2}/ =~ detail     
      puts $&
      @notice.date = get_unixtime($&)
      /［場所］/ =~ detail
      puts $'
#      @notice.place = $'
      @notice.category_id = category["イベント"]
      @notice.department_id = department["全て"]
      @notice.campus_id = campus["若松"]
      @notice.regist_time = Time.now.to_i
      begin
        @notice.save
        puts "save succeed"
        Kyutech_bot.tweet_new(@notice.title, category.key(@notice.category_id),
department.key(@notice.department_id), @notice.campus_id, @notice.web_url)
      rescue
        puts "no save"
      end
    end    

  end # task kit_b_hp

  desc "本日の予定をツイートする"
  task :morning_tweet => :environment do
    today = Date::today
    puts today
    unixtime = Time.parse(today.to_s).to_i
    puts unixtime
    Notice.where(date: unixtime).each do |recode|
      if recode.campus_id == 1
         @tweet_url = @tweet_base_url + recode.id.to_s
      else
         @tweet_url = recode.web_url
      end
      Kyutech_bot.tweet_morning(recode.title, category.key(recode.category_id),department.key(recode.department_id), recode.campus_id, @tweet_url)
    end
  
  end # task morning_tweet

end # namespace

