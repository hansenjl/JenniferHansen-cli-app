require_relative '../config/environment.rb'
class CLI
  attr_accessor :choice

  def call
    create_categories
    puts "Welcome to the Serious Eats Recipe Finder!"
    home_screen
  end

  def home_screen
    puts "What type of recipe are you looking for today?"
    list_categories
    choose_category
    current_category = Category.all[@choice.to_i-1]
    puts "Switching to the #{current_category.name} category."
    create_food(current_category)
    current_category.foods.each{|food| create_recipes(food)}
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
      home_screen
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
  end

  def create_recipes(food)
    recipe_info = Scraper.scrape_recipes(food.recipe_link)
    food.add_recipe(recipe_info)
  end

  def list_all_recipes(category)
  end


  def random_recipe(category)
    random_choice = rand(category.foods.count)
    puts category.foods[random_choice].name
    puts "Is this what you're looking for?"
    answer = yes_or_no
    if answer == "Y"
      display_recipe(category.foods[random_choice])
    else
      puts "If you would like a new random recipe, enter 1."
      puts "If you would like to go back one level, enter 2."
      puts "If you would like to return to the start, enter 3."
      input = gets.strip
      until ["1","2","3"].include?(input)
        puts "Please enter 1, 2, or 3."
        input = get.strip
      end
      case input
      when "1"
        random_recipe(category)
      when "2"
        category_prompts(category)
      when "3"
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

  def sort_by_ingredients(category)
  end

  def display_recipe(food)
    puts food.name
    puts "TIME TO MAKE: #{food.recipe.time}"
    puts "YIELD: #{food.recipe.serving}"
    puts "INGREDIENTS:"
    food.recipe.ingredients.each_with_index{|i,idx|
      puts "#{idx+1}. #{i}"}
    puts "STEPS:"
    food.recipe.steps.each_with_index{|s,idx|
      puts "#{idx+1}. #{s}"}
  end
end