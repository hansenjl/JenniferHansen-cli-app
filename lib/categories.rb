class Category
  attr_accessor :name, :food, :link
    @@all = []

  def initialize(category_hash)
    category_hash.each do |att, value|
      self.send("#{att}=",value)
    end
    @food = []
    @@all << self
  end

  def add_food(food_item)
    food = Food.new(food_item) if Food.all.include?(food_item) != true
    food.category = self.name
    @food << food
  end

  def self.all
    @@all
  end
end