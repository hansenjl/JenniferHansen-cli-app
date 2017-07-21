class Recipe
  attr_accessor :ingredients, :steps, :time, :serving, :food
  @@all = []
  def initialize(recipe_hash)
    recipe_hash.each do |attribute,value|
      self.send("#{attribute}=",value)
    end
    @@all << self
  end

  def self.all
    @@all
  end

  def find_by_ingredient(ingredient)
    matches = @@all.collect{|recipe|
      new_list = recipe.ingredients.collect{|i|i.downcase.include?(ingredient)}
      new_list.any?{|a|a==true}
    }
   # matches is an array of true or false results - true corresponds to it does contain that ingredient
    recipe_matches = []
    matches.each_with_index{|r,idx|
      recipe_matches<<@@all[idx] if r == true
      }
    recipe_matches
  end

end

