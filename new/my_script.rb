require 'pp'
require 'nokogiri'
require 'curb'
require 'csv'
require 'choice'

SEED = 'https://shop.mts.by/phones/'
SEED1 = 'https://shop.mts.by/phones/?page='
SEED2 = 'https://shop.mts.by'

def get_doc(url)
  puts url ||= SEED
  puts url
  c = Curl::Easy.new(SEED)
  c.perform
  Nokogiri::HTML(c.body_str)
end

def get_link(node)
   node.xpath('//div[@class="catalog_tovar_information"]/a[@class = "catalog_tovar_photo "]/@href').map(&:text).map do |smth|
 "#{SEED2}#{smth}"
   end
end

def get_all_link(node)
  node.xpath('//div[@class ="pagination"]/a[@class="next "]/preceding-sibling::a[1]/text()').text.to_i
end

object_nokogiri = get_doc(nil)
all_page = get_all_link(object_nokogiri)
link_on_page = get_link(object_nokogiri)
puts link_on_page

(2..all_page).each do |url|
  "#{SEED1}#{url}"
  object_nokogiri = get_doc("#{SEED1}#{url}")
  link_on_page = get_link(object_nokogiri)
  puts link_on_page
end
