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
    foods = food_page.css("div.module__wrapper")
    foods.each do |f|
      recipes << {
        :name => f.css("h4.title").text,
        :recipe_link => f.css("a")[0]["href"]
      }
    end
    recipes
  end

  def self.scrape_recipes(recipe_url)
    recipe_page = Nokogiri::HTML(open(recipe_url))
    main_info = recipe_page.css("section.entry-container")
    ingredient_section = main_info.css("div.recipe-ingredients li.ingredient")
    ingredient_array  = []
    ingredient_section.each {|item|
      ingredient_array << item.text
    }
    binding.pry
     recipe_info = {
      :ingredients => ingredient_array ,
      :steps=>2,
      :time=>2,
      :serving=> 2}
  end

end