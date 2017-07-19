require 'open-uri'
require 'nokogiri'

class Scraper
  def list_categories(categories_url)
    categories = []
    index_page = Nokogiri::HTML(open(categories_url))
    index_page.css("ul.nav-topics-list").each do |topic|
      category = topic.css("li.nav-topics-item span.label-topic").text
    categories << category
    end
  end
end