require 'spec_helper'

feature 'Accounts' do
  scenario "Creating an account" do
    visit subscribem.root_path
    click_link "Account Sign Up"
    fill_in 'Name', with: "Test"
    fill_in 'Email', with: "subscribem@example.com"

    password_field_id = "account_owner_attributes_password"
    fill_in password_field_id, with: 'password'
    fill_in "Password confirmation", with: 'password'

    click_button 'Create Account'

    success_message = 'Your account has been successfully created.'
    page.should have_content(success_message)
  end
end