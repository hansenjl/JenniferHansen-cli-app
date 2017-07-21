class Scraper

  def self.scrape_categories(categories_url)
    categories = []
    index_page = Nokogiri::HTML(open(categories_url))
    raw_categories = index_page.css("li.nav-topics-item")
    raw_categories.each{|cat|categories << {:name => cat.css("a")[0]["data-click-id"], :link => cat.css("a")[0]["href"]}}
    categories
  end

  def self.scrape_food_items(food_url)
    recipes = []
    food_page = Nokogiri::HTML(open(food_url))
    foods = food_page.css("div.module__wrapper")
    foods.each do |f|
      if f.css("a")[0]["href"].include?("recipes")
      recipes << {
        :name => f.css("h4.title").text,
        :recipe_link => f.css("a")[0]["href"]
      }
      else
      end
    end
    recipes
  end

  def self.scrape_recipes(recipe_url)
    recipe_page = Nokogiri::HTML(open(recipe_url))
    main_info = recipe_page.css("section.entry-container")
    ingredient_section = main_info.css("div.recipe-ingredients li.ingredient")
    ingredient_array = ingredient_section.collect {|item| item.text}
    ingredient_array.delete_if{|a|a.include?(":")}
    step_section = main_info.css("li.recipe-procedure")
    steps = step_section.collect{|s|s.css("div.recipe-procedure-text").text.strip}
    about_section = main_info.css("ul.recipe-about li")
     recipe_info = {
      :ingredients => ingredient_array,
      :steps=> steps,
      :serving=> about_section[0].css("span.info").text,
       }
       recipe_info[:time] = about_section[2].css("span.info").text if about_section[2] != nil
      recipe_info[:time] = about_section[1].css("span.info").text if about_section[2] ==nil
      recipe_info
  end

end