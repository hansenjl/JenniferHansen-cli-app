class Category
  attr_accessor :name, :foods, :link
    @@all = []

  def initialize(category_hash)
    category_hash.each do |att, value|
      self.send("#{att}=",value)
    end
    @foods = []
    @@all << self
  end

  def add_food(food_hash)
    food = Food.new(food_hash)
    food.category = self
    @foods << food
  end

  def self.all
    @@all
  end
end