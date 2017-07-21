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
    @@all.detect{|recipe|recipe.ingredients.include?(ingredient)}
  end

end