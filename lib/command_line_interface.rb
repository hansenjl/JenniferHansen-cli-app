require_relative '../config/environment.rb'
class CLI

  def call
    create_categories
    home_screen
  end

  def home_screen
    puts "Welcome to the Serious Eats Recipe Finder!"
    puts "What type of recipe are you looking for today?"
    list_categories
    puts "Please enter a number choice."
    choice = gets.strip
    until choice.to_i > 0 && choice.to_i <= num_of_categories
      puts "Please enter a number choice from 1 to #{num_of_categories}."
      choice = gets.strip
    end
    puts "Switching to the #{Category.all[choice.to_i-1].name} category."
    current_category = Category.all[choice.to_i-1]
    create_food(current_category.name)
  end

  def num_of_categories
    Category.all.count
  end

  def create_categories
    categories = Scraper.scrape_categories("http://www.seriouseats.com/recipes")
    categories.each{|c|
      Category.new(c.to_s)}
  end

  def list_categories
    Category.all.each_with_index{|c,idx|
      puts "#{idx+1}. #{c.name}" }
  end

  def create_food(category)
    foods = Scraper.scrape_food_items("http://www.seriouseats.com/tags/recipes/" +"#{category}")
  end


end