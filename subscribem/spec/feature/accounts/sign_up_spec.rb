require 'spec_helper'

feature 'Accounts' do
  scenario "Creating an account" do
    visit subscribem.root_path
    click_link "Account Sign Up"
    fill_in 'Name', with: "Test"
    click_button 'Create Account'

    success_message = 'Your account has been successfully created.'
    page.should have_content(success_message)
  end
end