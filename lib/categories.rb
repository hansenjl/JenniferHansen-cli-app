class Category
  attr_accessor :name, :food
    @@all = []
  def initialize(name)
    @name = name
    @food = []
    @@all << self
  end

  def add_food(food_item)
    food = Food.new(food_item) if Food.all.include?(food_item) != true
    food.category = self.name
    @food << food
  end

end