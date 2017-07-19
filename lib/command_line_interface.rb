require_relative '../config/environment.rb'
class CLI

  def call
    puts "Welcome to the Serious Eats Recipe Finder!"
    puts "What type of recipe are you looking for today?"
    list_categories

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