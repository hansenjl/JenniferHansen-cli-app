class Food
  attr_accessor :name, :category, :recipe_link, :recipe

  def initialize(recipe_hash)
    recipe_hash.each do |attribute,value|
      self.send("#{attribute}=",value)
    end

  end

end