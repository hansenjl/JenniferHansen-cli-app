class RecipeFinder::Food
  attr_accessor :name, :category, :recipe_link, :recipe
  @@all = []

  def initialize(recipe_hash)
    recipe_hash.each do |attribute,value|
      self.send("#{attribute}=",value)
    end
    @@all << self
  end

  def add_recipe(recipe_info)
    recipe = Recipe.new(recipe_info)
    recipe.food = self
    @recipe = recipe
  end

  def self.all
    @@all
  end

  def find_by_name(name)
    @@all.detect{|food|food.name.include?(name)}
  end
end