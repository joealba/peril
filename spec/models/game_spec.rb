require 'spec_helper'

require_relative "named_slug_examples"

describe Game do
  it_behaves_like "named slug"

  it "has many categories" do
    game     = FactoryGirl.create(:game)
    category = FactoryGirl.create(:category, game_id: game.id)
    expect(game.categories(true)).to eq([category])
  end

  it "preserves the order of categories" do
    game       = FactoryGirl.create(:game)
    categories = Array.new(3) { FactoryGirl.create(:category, game: game) }
    expect(game.categories(true)).to eq(categories)
  end

  it "removes categories with the game" do
    category = FactoryGirl.create(:category)
    category.game.categories(true)  # refresh the list so destroy() will see it
    category.game.destroy
    expect(Category.find_by_id(category.id)).to be_nil
  end

  it "has many rewards" do
    game   = FactoryGirl.create(:game)
    reward = FactoryGirl.create(:reward, game_id: game.id)
    expect(game.rewards).to eq([reward])
  end

  it "preserves the order of rewards" do
    game    = FactoryGirl.create(:game)
    rewards = Array.new(3) { FactoryGirl.create(:reward, game: game) }
    expect(game.rewards).to eq(rewards)
  end

  it "removes rewards with the game" do
    reward = FactoryGirl.create(:reward)
    reward.game.destroy
    expect(Reward.find_by_id(reward.id)).to be_nil
  end

  it "requires a reward for each answer" do
    game     = Game.new(name: "Game")
    category = game.categories.build(name: "Category")
    category.answers.build(body: "A1", question: "Q1")
    category.answers.build(body: "A2", question: "Q2")
    game.rewards.build(score: 200)
    expect(game).to have_an_invalid_field(:categories)

    game.rewards.build(score: 400)
    expect(game).to have_a_valid_field(:categories)
  end
end