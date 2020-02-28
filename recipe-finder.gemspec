# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "recipe_finder/version"

Gem::Specification.new do |spec|
  spec.name          = "recipe_finder"
  spec.version       = RecipeFinder::VERSION
  spec.authors       = ["hansenjl"]
  spec.email         = ["jenn.leigh.hansen@gmail.com"]

  spec.summary       = %q{Recipe finder}
  spec.description   = %q{Recipe finder}
  spec.homepage      = "https://github.com/hansenjl/JenniferHansen-cli-app"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "colorize"
end
