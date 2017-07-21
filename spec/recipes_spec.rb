require "spec_helper"

RSpec.describe Recipes do
  it "has a version number" do
    expect(Recipes::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
