require File.dirname(__FILE__) + '/acceptance_helper'

feature "Header navigation", %q{
  In order to navigate around the site
  As a user
  I want to use the header navigation menu } do

  background do
    visit "/"
  end

  scenario "Convos button" do
    click_link("nav_convos_link")
    page.should have_content("Listing convos")
  end

end
