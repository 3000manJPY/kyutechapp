#これを忘れたらあかんで〜〜〜〜
#Xvfb :1 -screen 0 1024x768x24
#export DISPLAY=:1
#firefox &
#

require "selenium-webdriver"
require 'nokogiri'

namespace :cron_syllabus do
@SYLLABUS_UPDATE_TIME = "com.planningdev.kyutech.lecture.update"
@rebootCount = 0
@MAX_REBOOT = 20

@linkCount = 0
@campus_num = 0
@campusList = {"工学府授業科目"=> 0,
	"工学部授業科目"=>0,
	"生命体授業科目"=>2,
	"情報工学府授業科目"=>1,
	"情報工学部授業科目"=>1
	}

  desc "cron sillabus"
  task :syllabus => :environment do

    setServerTime()
    first = 1
    if !(ENV['START_NUM'].nil?)
      first = ENV['START_NUM'].to_i
    end

    cronBoot(first)

  end

  def setServerTime()
      Rails.cache.write @SYLLABUS_UPDATE_TIME, Time.now.to_i

  end

  ###########################################
  #  boot(link_index) 
  ###########################################
  def cronBoot(first)
    setup()
    links = getLinks()
    @linkLength = links.count - 1
    subIds = getSubIdList(1,@linkLength)
    p links.count
    p subIds.count
    for val in first..@linkLength
      @linkCount = val
      p val    
      cron(links[val],subIds[val])
    end
  end

  ###########################################
  #  get links   
  ############################################ 
  def setup

    @driver = Selenium::WebDriver.for :firefox
    @driver.navigate.to "http://syllabus.jimu.kyutech.ac.jp/syllabus/"

    element = @driver.find_element(:name, 'freeWord')
    element.send_keys " "
    #element.send_keys "システム制御コンピューティング"

    @driver.execute_script "return changeComponent('10126D10D393673BE4CED4D8BEB66F35.kmap1', 'search');return dbClick();"

    sleep 2

    html = @driver.page_source
    @row = Nokogiri::HTML(html)
  end 

  def getLinks
    links =  @row.css("img")
    return links
  end
 
  def getSubIdList(first,length)
    subIdList = []
    @row.xpath('/html/body/table[5]/tbody/tr/td/table/tbody').each do |node|
      for i in first..length
        subIdList.push(node.xpath('tr[' + (i.to_i).to_s + ']/td[3]/div').text)
      end
    end 
    return subIdList
  end

  ###########################################
  # cron      
  ########################################### 
  def cron(val,subId)
    begin
      @driver.execute_script val[:onclick]
      sleep 1
    rescue Timeout::Error
      p "Time out 1!!!!!!!!!!"
      cronReboot()
    rescue => e
      p "other error1"
      p e
    end

    html = @driver.page_source
    doc = Nokogiri::HTML(html)
    #doc.xpath('/html/body/table[4]/tbody/tr/td/table/tbody/tr[1]/td[2]').each do |node|
    doc.xpath('/html/body/table[4]/tbody/tr/td/table/tbody').each do |node|
      @list = node.xpath('tr[5]/td[2]').text.gsub(/([\t| |\n|　]+)/,"")
      #@list.split(",").each_with_index do |week_time, cnt|
      cnt = 0
	week_time = weekTimeVal(@list)
        @lecture = Lecture.new

      #puts node.text.gsub(/([\t| |\n|?~@~@]+)/,"")
     # puts node.xpath('tr[1]/td[2]').text.gsub(/([\t| |\n|　]+)/,"")
        @lecture.title = node.xpath('tr[1]/td[2]').text.gsub(/([\t| |\n|　]+)/,"")
        p @lecture.title + cnt.to_s
        @lecture.sub_id = subId
        @lecture.teacher = node.xpath('tr[2]/td[2]').text.gsub(/([\t| |\n|　]+)/,"")
        @lecture.year = node.xpath('tr[3]/td[2]').text.gsub(/([\t| |\n|　]+)/,"")
        @lecture.class_num = node.xpath('tr[3]/td[4]').text.gsub(/([\t| |\n|　]+)/,"").gsub(/[[:space:]]/, '')
        @lecture.room = node.xpath('tr[4]/td[2]').text.gsub(/([\t| |\n|　]+)/,"").gsub(/(講義室|\(情\)|（情）)/,"")
        @lecture.term = getTermVal(node.xpath('tr[4]/td[4]').text.gsub(/([\t| |\n|　]+)/,""))
        @lecture.week_time = week_time
        @lecture.required = getRequired(node.xpath('tr[5]/td[4]').text.gsub(/([\t| |\n|　]+)/,""))
        @lecture.campus_id = getCampusId(node.xpath('tr[6]/td[2]').text.gsub(/([\t| |\n|　]+)/,"") { [$1].pack('H*').unpack('n*').pack('U') })
        @lecture.credit = node.xpath('tr[6]/td[4]').text.gsub(/([\t| |\n|　]+)/,"").to_i
        @lecture.title_en = getEnglishTitle(node.xpath('tr[7]/td[2]').text.gsub(/([\t| |　]+)/,"").gsub(/([\n]+)/,"\n"))
        @lecture.purpose = getPurposeWithNode(node)
        @lecture.overview = getOverViewWithNode(node)
        @lecture.keyword = getKeyWordWithNode(node)
        @lecture.plan = getPlanWithNode(node)
        @lecture.evaluation = getEvaluationWithNode(node)
        @lecture.book = getBookWithNode(node)
        @lecture.preparation = getPreparationWithNode(node)
        @lecture.id = (@campus_num.to_s  + @lecture.sub_id.to_s + @lecture.class_num.to_s + cnt.to_s).to_i
        @lecture.created_at = Time.now.to_i
        @lecture.updated_at= Time.now.to_i
        #p @lecture

        begin
          @lecture.save
          puts "save succeed"
        rescue ActiveRecord::RecordInvalid => e
          puts e
        rescue
          p @lecture
          puts "no save!!!!!!!!!!!\n!\n!\n!\n!\n!\n!\n!\n!\n!\n!\n!\n!\n\!!!!!!!!!!!!!!!!!!!"
        end
    #  end
    end
#    puts "=====================================\n\n\n\n"
    back()
  end

  ###########################################
  # back button click    
  ###########################################   
  def back

    begin
      element = @driver.find_element(:name, "button_kind.back")
      element.click

    rescue Selenium::WebDriver::Error::WebDriverError => e
      p "Time out 2!!!!!!!!!!"
      cronReboot()

    rescue => e
      p "other error2"
      p e
    end

    sleep 1
  end

  ###########################################
  #  get campus id
  #  campus list
  #
  #  campus_id | index | campus
  #     0      |   0   | kougakubu
  #     0      |   1   | kougakuhu
  #     1      |   2   | seimei
  #     2      |   3(4)| jouhoukougakubu(hu)
  ########################################### 
  
  def getTermVal(str)
    str = str.gsub(/([\t| |\n|　]+)/,"").gsub(/[[:space:]]/, '')
    if str == "前期"
      return "1,2"
    elsif str == "後期"
      return "3,4"
    elsif str == "通年"
      return "1,2,3,4"
    elsif str == "集中"
      return "99"
    else
      return "0" 
    end
  end

  def getCampusId(str)
    str = str.gsub(/([\t| |\n|　]+)/,"").gsub(/[[:space:]]/, '')
#p str
    @campusList.each_with_index do |(campus,num),index|
#p campus.to_s
      
      if campus.to_s == str.to_s
	@campus_num = index
	return num
      end 
    end 
    return 99
  end


  ###########################################
  #  get required      
  ########################################### 
  def getRequired(str)
    if str.to_s.include?("選択") && str.to_s.include?("必修")
      return 1
    elsif str.to_s.include?("必修")
      return 0
    elsif str.to_s.include?("選択")
      return 2
    end
    return 3
  end


  ###########################################
  #  get english title
  ########################################### 
  def getEnglishTitle(str)
    if @campus_num == 2
      return ""
    else
      return str
    end
  end
  
  ###########################################
  #  get purpose
  ########################################### 
  def getPurposeWithNode(node)
    if @campus_num == 0
      return node.xpath('tr[8]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @campus_num == 1
      return node.xpath('tr[10]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @campus_num == 3 || @campus_num == 4
      return node.xpath('tr[12]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    else
      return ""
    end    
  end

  ###########################################
  #  get orverview 
  ########################################### 
  def getOverViewWithNode(node)
    if @campus_num == 2
      return node.xpath('tr[7]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @campus_num == 1 || @campus_num == 3 || @campus_num == 4
      return node.xpath('tr[8]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    else
      return ""
    end    
  end

  ###########################################
  #  Keyword of lecture
  ########################################### 
  def getKeyWordWithNode(node)
    if @campus_num == 1
      return node.xpath('tr[9]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @campus_num == 3 || @campus_num == 4
      return node.xpath('tr[15]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    else
      return ""
    end
  end


  ###########################################
  #  Lesson plans
  ########################################### 
  def getPlanWithNode(node)
    if @campus_num == 0
      return node.xpath('tr[9]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @campus_num == 1
      return node.xpath('tr[11]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @camppus_num == 2
      return node.xpath('tr[8]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @campus_num == 3 || @campus_num == 4
      return node.xpath('tr[10]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    else
      return ""
    end    
  end

  ###########################################
  # Evaluation of class 
  ########################################### 
  def getEvaluationWithNode(node)
    if @campus_num == 0
      return node.xpath('tr[10]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @campus_num == 1
      return node.xpath('tr[12]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @camppus_num == 2
      return node.xpath('tr[9]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @campus_num == 3 || @campus_num == 4
      return node.xpath('tr[13]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    else
      return ""
    end
  end


  ###########################################
  #  Reference book of lesson    
  ########################################### 
  def getBookWithNode(node)
    if @campus_num == 0
      return node.xpath('tr[12]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @campus_num == 1
      return node.xpath('tr[15]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @camppus_num == 2
      return node.xpath('tr[12]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @campus_num == 3 || @campus_num == 4
      return node.xpath('tr[16]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n") + node.xpath('tr[17]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    else
      return ""
    end
  end


  ###########################################
  #  Preparation of lesson   
  ########################################### 
  def getPreparationWithNode(node)
    if @campus_num == 0
      return node.xpath('tr[13]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @camppus_num == 2
      return node.xpath('tr[11]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    elsif @campus_num == 1 || @campus_num == 3 || @campus_num == 4
      return node.xpath('tr[14]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    else
      return ""
    end
  end


  ###########################################
  #  timeout -> reinit
  ########################################### 
  def cronReboot
    @rebootCount += 1
    if @rebootCount > @MAX_REBOOT
      p "RETRY20!!! EXIT NOW !!"
      exit

    end
    @driver.quit
    p "quitting!!!!!"
    p "quitting!!!!!"
    p "quitting!!!!!"
    p "quitting!!!!!"
    p "quitting!!!!!"
    p "quitting!!!!!"
    p "quitting!!!!!"
    p "quitting!!!!!"
    p "quitting!!!!!"
    p "quitting!!!!!"
    p "quitting!!!!!"
    @driver = nil
    p "rebooting!!!"
    sleep 3
    
    cronBoot(@linkCount)

  end

  def weekTimeVal(val)
    if val == "時間外"
      return 99
    end
    @resval = []
    val.split(",").each_with_index do |week_time, cnt|    
      str = week_time.to_s
      @numStr = weekNumber(str[0])
      if @numStr.to_s == "99"
        return 99
      end
      time_val = str[1].tr("０-９", "0-9")
      if time_val == nil
        return 99
      end
      @resval.push(@numStr.to_s + time_val.to_s)
    end
    return @resval.join(",")
  end

  def weekNumber(value)
    if value == "月"
      return "1"
    elsif value == "火"
      return "2"
    elsif value == "水"
      return "3"
    elsif value == "木"
      return "4"
    elsif value == "金"
      return "5"
    else
      return "99"
    end
  end
end
