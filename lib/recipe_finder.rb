require 'bundler' #Load bundler
Bundler.require # Require the Gems from Gemfile using bundler
require 'open-uri'
require 'colorize'
require 'nokogiri'
require 'pry'

#Load Libraries
require_relative '../lib/recipe_finder/food_item.rb'
require_relative '../lib/recipe_finder/categories.rb'
require_relative '../lib/recipe_finder/recipe.rb'
require_relative '../lib/recipe_finder/scraper.rb'
require_relative '../lib/recipe_finder/command_line_interface.rb'

module RecipeFinder
end