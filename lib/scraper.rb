require 'open-uri'
require 'nokogiri'

class Scraper

  def self.scrape_categories(categories_url)
    categories = []
    index_page = Nokogiri::HTML(open(categories_url))
    raw_categories = index_page.css("li.nav-topics-item")
    raw_categories.each{|cat|categories << {:name => cat.css("a")[0]["data-click-id"], :link => cat.css("a")[0]["href"]}}
    categories
  end

  def self.scrape_food_items(food_url)
    recipes = []
    food_page = Nokogiri::HTML(open(food_url))
    foods = food_page.css("section.block-has-author  div.module")
    foods.each do |f|
      recipes << {
        :name => f.css("h4.title").text,
        :author => f.css("p.author").text,
        :recipe_link => f.css("a")[0]["href"]
      }
      binding.pry

    end
    food_items
  end

end