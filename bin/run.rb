#!/usr/bin/env ruby
require_relative '../config/environment.rb'

def create_categories
  categories = Scraper.list_categories("http://www.seriouseats.com/recipes")
  categories.each{|c|
    Category.new(c.to_s)}
end