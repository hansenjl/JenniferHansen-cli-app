require_relative '../config/environment.rb'
require 'colorize'
class CLI
  attr_accessor :choice

  def call
    create_categories
    puts "Welcome to the Serious Eats Recipe Finder!".colorize(:blue)
    home_screen
  end

  def home_screen
    puts "What type of recipe are you looking for today?"
    list_categories
    choose_category
    current_category = Category.all[@choice.to_i-1]
    puts "Switching to the #{current_category.name} category.".colorize(:blue)
    create_food(current_category)
    current_category.foods.each{|food| create_recipes(food)}
    category_prompts(current_category)
  end


  def category_prompts(current_category)
    puts "What would you like to do?"
    puts "1. List all recipes".colorize(:blue)
    puts "2. Surprise me with a recipe".colorize(:blue)
    puts "3. Sort recipes by total cook time".colorize(:blue)
    puts "4. Sort recipes by number of ingredients".colorize(:blue)
    puts "5. Search by ingredient".colorize(:blue)
    puts "6. Go back".colorize(:blue)
    puts "Enter the number choice that represents what you want to do."
    recipe_choice = gets.strip
    until recipe_choice.to_i > 0 && recipe_choice.to_i < 6
      puts "Please enter a number choice from 1 to 5."
      recipe_choice = gets.strip
    end
    navigate_to_recipe(recipe_choice,current_category)
  end

  def navigate_to_recipe(recipe_choice,category)
    case recipe_choice
    when "1"
      list_all_recipes(category)
    when "2"
      random_recipe(category)
    when "3"
      sort_by_time(category)
    when "4"
      sort_by_ingredients(category)
    when "5"
      search_by_ingredient(category)
    when "6"
      home_screen
    end
  end

  def choose_category
    puts "Please enter a number choice."
    @choice = gets.strip
    until @choice.to_i > 0 && @choice.to_i <= Category.size
      puts "Please enter a number choice from 1 to #{Category.size}."
      @choice = gets.strip
    end
    @choice
  end

  def create_categories
    categories = Scraper.scrape_categories("http://www.seriouseats.com/recipes")
    categories.each{|c|
      Category.new(c)}
  end

  def list_categories
    Category.all.each_with_index{|c,idx|
      puts "#{idx+1}. #{c.name}".colorize(:blue) }
  end

  def create_food(category)
    recipes = Scraper.scrape_food_items("http://www.seriouseats.com" +"#{category.link}")
    recipes.each{|r|
      category.add_food(r)}
  end

  def create_recipes(food)
    recipe_info = Scraper.scrape_recipes(food.recipe_link)
    food.add_recipe(recipe_info)
  end

  def sort_by_ingredients(category)
    ##sorting
    sorted_foods = category.foods.sort do |a,b|
      a.recipe.ingredients.count <=> b.recipe.ingredients.count
    end
    ##display
    puts "All #{category.name} recipes listed in order from least number of ingredients to most number of ingredients:"
    sorted_foods.each_with_index{|f,idx|
      puts "#{idx+1}. "+"#{f.name}".colorize(:blue)}
    input = recipe_list_choosing(category, category.foods.count)
    display_recipe(sorted_foods[input.to_i-1]) if input.to_i != 0
    display_after_recipe(category)

  end

  def list_all_recipes(category)
    puts "All of the #{category.name} recipes:"
    category.foods.each_with_index{|food, idx|
      puts "#{idx +1}. " + food.name.colorize(:blue)}
    input = recipe_list_choosing(category, category.foods.count)
    display_recipe(category.foods[input.to_i-1]) if input.to_i != 0
    display_after_recipe(category)
  end

  def recipe_list_choosing(category,num_of_choices)
    puts "Which recipe would you like to view? Enter the number that corresponds to the recipe or type 'back' to go back."
    input = gets.strip
      if ["back","go back","bac"].include?(input.downcase)
        category_prompts(category)
      else
        until input.to_i > 0 && input.to_i <= num_of_choices
          puts "Please enter the number that matches the recipe you would like to view."
          input = gets.strip
        end
      end
    input
  end


  def random_recipe(category)
    random_choice = rand(category.foods.count)
    puts category.foods[random_choice].name.colorize(:blue)
    puts "Is this what you're looking for?"
    answer = yes_or_no
    if answer == "Y"
      display_recipe(category.foods[random_choice])
      display_after_recipe(category)
    else
      puts "If you would like a new random recipe, enter 'new'.".colorize(:blue)
      puts "If you would like to go back one level, enter 'back'.".colorize(:blue)
      puts "If you would like to return to the start, enter 'home'.".colorize(:blue)
      input = gets.strip.downcase
      until ["n","new","b","back","h","home"].include?(input)
        puts "Please enter NEW, BACK, or HOME."
        input = gets.strip.downcase
      end
      case input
      when "new","n"
        random_recipe(category)
      when "back", "b"
        category_prompts(category)
      when "home", "h"
        home_screen
      end
    end
  end


  def yes_or_no
    answer = gets.strip
    if ["Y", "YES", "YA", "SI"].include?(answer.upcase)
      "Y"
    elsif ["N", "NO"].include?(answer.upcase)
      "N"
    else
      puts "Please enter yes or no."
      yes_or_no
    end
  end


  def sort_by_time(category)
  end



  def search_by_ingredient(category)
    puts "What ingredient are you searching for?"
    input = gets.strip.downcase
    matching_recipes = []
    matching_recipes = category.foods[0].recipe.find_by_ingredient(input)
    if matching_recipes.count == 0
      puts "I'm sorry, there wasn't a recipe that matched the ingredient."
      puts " Please try again."
      search_by_ingredient(category)
    else
      puts "These are the recipes that we found:"
      matching_recipes.each_with_index{|recipe,idx|
        puts "#{idx+1}. "+"#{recipe.food.name}".colorize(:blue)}
      choice = recipe_list_choosing(category,matching_recipes.count)
      display_recipe(matching_recipes[choice.to_i-1].food) if choice.to_i != 0
      display_after_recipe(category)
    end
  end

  def display_recipe(food)
    puts food.name.upcase.colorize(:magenta)
    puts "TIME TO MAKE:" + "#{food.recipe.time}".colorize(:magenta)
    puts "YIELD:" + "#{food.recipe.serving}".colorize(:magenta)
    puts "INGREDIENTS:"
    food.recipe.ingredients.each_with_index{|i,idx|
      puts "#{idx+1}. "+"#{i}".colorize(:magenta)}
    puts "STEPS:"
    puts food.recipe.steps[0].colorize(:magenta) if food.recipe.steps.count == 1
    food.recipe.steps.each_with_index{|s,idx|
      puts "#{idx+1}."+" #{s}".colorize(:magenta)}
    puts "LINK:"
    puts "#{food.recipe_link}".colorize(:magenta)
  end

  def display_after_recipe(category)
    puts "Are you done using the recipe finder today?"
    answer = yes_or_no
    if answer == "N"
      puts "What would you like to do?"
      puts "If you would like to go back one level, enter 'back'.".colorize(:blue)
      puts "If you would like to return to the start, enter 'home'.".colorize(:blue)
      input = gets.strip.downcase
      until ["b","back","h","home"].include?(input)
        puts "Please enter BACK or HOME."
        input = gets.strip.downcase
      end
      case input
      when "back", "b"
        category_prompts(category)
      when "home", "h"
        home_screen
      end
      puts
    else
      abort("Goodbye!")
    end
  end
end