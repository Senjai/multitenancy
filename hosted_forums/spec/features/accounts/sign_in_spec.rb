require 'spec_helper'
require 'subscribem/testing_support/subdomain_helpers'
require 'subscribem/testing_support/factories/accounts_factory'
require 'subscribem/testing_support/factories/users_factory'

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
end