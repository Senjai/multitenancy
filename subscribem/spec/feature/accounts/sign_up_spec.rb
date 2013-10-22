require 'spec_helper'
require 'subscribem/testing_support/subdomain_helpers'

feature 'Accounts' do
  scenario "Creating an account" do
    visit subscribem.root_path
    click_link "Account Sign Up"
    fill_in 'Name', with: "Test"
    fill_in 'Subdomain', with: "test"
    fill_in 'Email', with: "subscribem@example.com"

    password_field_id = "account_owner_attributes_password"
    fill_in password_field_id, with: 'password'
    fill_in "Password confirmation", with: 'password'

    click_button 'Create Account'

    success_message = 'Your account has been successfully created.'
    page.should have_content(success_message)
    page.should have_content("Signed in as subscribem@example.com")
    page.current_url.should == "http://test.example.com/"
  end

  scenario "Ensure subdomain uniqueness" do
    Subscribem::Account.create!(subdomain: "test", name: "Test")
    visit subscribem.root_path

    click_link 'Account Sign Up'
    fill_in "Name", with: "Test"
    fill_in "Subdomain", with: "test"
    fill_in "Email", with: "subscribem@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_button "Create Account"
    page.current_url.should == "http://example.com/accounts"
    page.should have_content("Sorry, your account could not be created.")
    page.should have_content("Subdomain has already been taken")
  end

  scenario "Subdomain with restricted name" do
    visit subscribem.root_path
    click_link 'Account Sign Up'

    fill_in "Name", with: "Test"
    fill_in "Subdomain", with: "admin"
    fill_in "Email", with: "subscribem@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_button "Create Account"
    page.current_url.should == "http://example.com/accounts"
    page.should have_content("Sorry, your account could not be created.")
    page.should have_content("Subdomain is not allowed. Please choose another subdomain.")
  end

  scenario "Subdomain with invalid name" do
    visit subscribem.root_path
    click_link 'Account Sign Up'

    fill_in "Name", with: "Test"
    fill_in "Subdomain", with: "<admin>"
    fill_in "Email", with: "subscribem@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_button "Create Account"
    page.current_url.should == "http://example.com/accounts"
    page.should have_content("Sorry, your account could not be created.")
    page.should have_content("Subdomain is not allowed. Please choose another subdomain.")
  end
end

feature "user sign in" do
  extend Subscribem::TestingSupport::SubdomainHelpers

  let!(:account) { FactoryGirl.create(:account_with_schema) }
  let(:sign_in_url) { "http://#{account.subdomain}.example.com/sign_in" }
  let(:root_url) { "http://#{account.subdomain}.example.com/" }

  within_account_subdomain do
    scenario "signs in as account owner successfully" do
      visit root_url
      page.current_url.should == sign_in_url
      fill_in "Email", with: account.owner.email
      fill_in "Password", with: "password"
      click_button "Sign In"
      page.should have_content("You are now signed in.")
      page.current_url.should == root_url
    end
  end

  scenario "attempts sign in with invalid password and fails miserably" do
    visit subscribem.root_url(subdomain: account.subdomain)
    page.current_url.should == sign_in_url
    page.should have_content("Please sign in.")

    fill_in "Email", with: account.owner.email
    fill_in "Password", with: "ladidahhhhh"
    click_button "Sign In"

    page.should have_content("Invalid email or password.")
    page.current_url.should == sign_in_url
  end

  scenario "attempts sign in with invalid email and fails miserably" do
    visit subscribem.root_url(subdomain: account.subdomain)
    page.current_url.should == sign_in_url
    page.should have_content("Please sign in.")

    fill_in "Email", with: "foo@example.com"
    fill_in "Password", with: "password"
    click_button "Sign In"

    page.should have_content("Invalid email or password.")
    page.current_url.should == sign_in_url
  end

  scenario "Cannot sign in if not a part of this subdomain" do
    other_account = FactoryGirl.create(:account)

    visit subscribem.root_url(subdomain: account.subdomain)
    page.current_url.should == sign_in_url
    page.should have_content("Please sign in.")

    fill_in "Email", with: other_account.owner.email
    fill_in "Password", with: "password"
    click_button "Sign In"

    page.should have_content("Invalid email or password.")
    page.current_url.should == sign_in_url
  end
end

feature "User sign up" do
  let!(:account) {FactoryGirl.create(:account_with_schema)}
  let(:root_url) {"http://#{account.subdomain}.example.com/"}

  scenario "under an account" do
    visit root_url
    page.current_url.should == root_url + "sign_in"
    click_link "New User?"

    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    page.should have_content("You have signed up successfully.")
    page.current_url.should eql(root_url)
  end
end