require 'open-uri'
require 'nokogiri'

class Scraper

  def self.scrape_categories(categories_url)
    categories = []
    index_page = Nokogiri::HTML(open(categories_url))
    raw_categories = index_page.css("ul.nav-topics-list").text.split("\n")
    raw_categories.pop
    raw_categories.shift
    raw_categories.each{|cat|categories << cat.strip}
    categories
  end

  def self.scrape_food_items(food_url)
    recipes = []
    food_page = Nokogiri::HTML(open(food_url))
    foods = food_page.css("div.module")
    foods.each do |f|
      recipes << {
        :name => f.css("h4.title").text
        :author => f.css("p.author").text
        :recipe_link =>

      }
    end
    food_items
  end

end