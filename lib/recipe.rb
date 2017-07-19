class Recipe
  attr_accessor :ingredients, :steps, :time, :serving

  def initialize(recipe_hash)
    recipe_hash.each do |attribute,value|
      self.send("#{attribute}=",value)
    end
  end

end