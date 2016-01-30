#!/usr/bin/ruby
## -*- coding: utf-8 -*-

require "selenium-webdriver"
require 'nokogiri'

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "http://syllabus.jimu.kyutech.ac.jp/syllabus/"

element = driver.find_element(:name, 'freeWord')

element.send_keys " " 

driver.execute_script "return changeComponent('10126D10D393673BE4CED4D8BEB66F35.kmap1', 'search');return dbClick();"

sleep 1

html = driver.page_source
doc = Nokogiri::HTML(html)
links = doc.css("img").each do |val|

  driver.execute_script val[:onclick]
  sleep 1

  html = driver.page_source
  doc = Nokogiri::HTML(html)
  #doc.xpath('/html/body/table[4]/tbody/tr/td/table/tbody/tr[1]/td[2]').each do |node|
  doc.xpath('/html/body/table[4]/tbody/tr/td/table/tbody').each do |node|

    #puts node.text.gsub(/([\t| |\n|　]+)/,"")
    puts node.xpath('tr[1]/td[2]').text.gsub(/([\t| |\n|?~@~@]+)/,"")

    puts node.xpath('tr[2]/td[2]').text.gsub(/([\t| |\n|?~@~@]+)/,"")
    puts node.xpath('tr[3]/td[2]').text.gsub(/([\t| |\n|?~@~@]+)/,"")
    puts node.xpath('tr[3]/td[4]').text.gsub(/([\t| |\n|?~@~@]+)/,"")
    puts node.xpath('tr[4]/td[2]').text.gsub(/([\t| |\n|?~@~@]+)/,"")
    puts node.xpath('tr[4]/td[4]').text.gsub(/([\t| |\n|?~@~@]+)/,"")
    puts node.xpath('tr[5]/td[2]').text.gsub(/([\t| |\n|?~@~@]+)/,"")
    puts node.xpath('tr[5]/td[4]').text.gsub(/([\t| |\n|?~@~@]+)/,"")
    puts node.xpath('tr[6]/td[2]').text.gsub(/([\t| |\n|?~@~@]+)/,"")
    puts node.xpath('tr[6]/td[4]').text.gsub(/([\t| |\n|?~@~@]+)/,"")
    puts node.xpath('tr[7]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    puts node.xpath('tr[8]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    puts node.xpath('tr[9]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    puts node.xpath('tr[10]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    puts node.xpath('tr[11]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    puts node.xpath('tr[12]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    puts node.xpath('tr[13]/td[2]').text.gsub(/([\t| |?~@~@]+)/,"").gsub(/([\n]+)/,"\n")
    puts "=====================================\n\n\n\n"

  end

  element = driver.find_element(:name, "button_kind.back")
  element.click

end



