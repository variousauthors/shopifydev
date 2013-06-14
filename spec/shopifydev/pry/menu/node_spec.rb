require 'spec_helper'
include Shopifydev::Pry::Menu

describe "Shopifydev::Pry::Menu::HeaderNode" do
  describe "#draw" do
    it "displays a blue header" do
      node = HeaderNode.new("Header")
      expect(node.draw).to eq(Color.blue { "Header" })
    end
  end
end

describe "Shopifydev::Pry::Menu::ChoiceNode" do

  describe "#draw" do
    it "displays a yellow number and a choice" do
      node = ChoiceNode.new("Choice", 0)
      expect(node.draw).to eq(Color.yellow{ 0.to_s } + '. ' + "Choice")
    end
  end
end

