require_relative '../config/environment.rb'
class CLI

  def call
    create_categories
  end

  def create_categories
    categories = Scraper.list_categories("http://www.seriouseats.com/recipes")
    categories.each{|c|
      Category.new(c.to_s)}
  end


end