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
    matching_recipes = @@all.collect{|recipe|
      new_list = recipe.ingredients.collect{|i|i.downcase.include?(ingredient)}
      new_list.any?{|a|a==true}
    }
    matching_recipes  #an array of true or false results - true corresponds to it does contain that ingredient
    recipe_names = []
    matching_recipes.each_with_index{|r,idx|
      recipe_names<<@@all[idx].food.name if r == true
      }
    recipe_names
    binding.pry
  end

end

