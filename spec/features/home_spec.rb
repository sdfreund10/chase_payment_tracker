require 'rails_helper'

class Home
  include Capybara::DSL
  def visit_homepage
    visit('/')
  end
end

RSpec.describe "Visit homepage", type: :feature do
  let(:home) { Home.new }
  scenario "Able to see text, Word Nerds", :js => true do
    home.visit_homepage
    expect(page).to have_content("Hello React")
  end
end