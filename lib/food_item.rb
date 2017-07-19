class Food
  attr_accessor :name, :category, :author, :recipe_link, :ingredients, :steps, :time, :serving

  def initialize(recipe_hash)
    recipe_hash.each do |attribute,value|
      self.send("#{attribute}=",value)
    end
  end

end