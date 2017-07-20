class Recipe
  attr_accessor :ingredients, :steps, :time, :serving
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

end