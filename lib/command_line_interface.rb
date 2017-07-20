require_relative '../config/environment.rb'
class CLI
  attr_accessor :choice

  def call
    create_categories
    home_screen
  end

  def home_screen
    puts "Welcome to the Serious Eats Recipe Finder!"
    puts "What type of recipe are you looking for today?"
    list_categories
    choose_category
    puts "Switching to the #{Category.all[@choice.to_i-1].name} category."
    current_category = Category.all[@choice.to_i-1]
    foods = create_food(current_category)
    binding.pry
    category_prompts(current_category)
  end


  def category_prompts(current_category)
    puts "What would you like to do?"
    puts "1. List all recipes"
    puts "2. Surprise me with a recipe"
    puts "3. Sort recipes by total cook time"
    puts "4. Sort recipes by number of ingredients"
    puts "5. Go back"
    puts "Enter the number choice that represents what you want to do."
    recipe_choice = gets.strip
    until recipe_choice.to_i > 0 && recipe_choice.to_i < 6
      puts "Please enter a number choice from 1 to 5."
      recipe_choice = gets.strip
    end
  end

  def choose_category
    puts "Please enter a number choice."
    @choice = gets.strip
    until @choice.to_i > 0 && @choice.to_i <= num_of_categories
      puts "Please enter a number choice from 1 to #{num_of_categories}."
      @choice = gets.strip
    end
    @choice
  end

  def num_of_categories
    Category.all.count
  end

  def create_categories
    categories = Scraper.scrape_categories("http://www.seriouseats.com/recipes")
    categories.each{|c|
      Category.new(c)}
  end

  def list_categories
    Category.all.each_with_index{|c,idx|
      puts "#{idx+1}. #{c.name}" }
  end

  def create_food(category)
    recipes = Scraper.scrape_food_items("http://www.seriouseats.com" +"#{category.link}")
    recipes.each{|r|
      category.add_food(r)}
    #recipes.each{|r|
     # Food.new(r)}

  end


end