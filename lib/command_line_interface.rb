require_relative '../config/environment.rb'
class CLI

  def call
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


  end

  def num_of_categories
    Category.all.count
  end

  def create_categories
    categories = Scraper.list_categories("http://www.seriouseats.com/recipes")
    categories.each{|c|
      Category.new(c.to_s)}
  end

  def list_categories
    create_categories.each_with_index{|c,idx|
      puts "#{idx+1}. #{c}" }
  end


end