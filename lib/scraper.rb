require 'open-uri'
require 'nokogiri'

class Scraper
  def self.list_categories(categories_url)
    categories = []
    index_page = Nokogiri::HTML(open(categories_url))
    raw_categories = index_page.css("ul.nav-topics-list").text.split("\n")
    raw_categories.pop
    raw_categories.shift
    raw_categories.each{|cat|categories << cat.strip}
    categories
    binding.pry
  end
end