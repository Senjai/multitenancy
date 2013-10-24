require 'spec_helper'
require 'subscribem/testing_support/factories/accounts_factory'
require 'subscribem/testing_support/factories/users_factory'
require 'subscribem/testing_support/authentication_helpers'

feature "Accounts" do
  include Subscribem::TestingSupport::AuthenticationHelpers
  let!(:account) {FactoryGirl.create(:account_with_schema)}
  let(:root_url) {"http://#{account.subdomain}.example.com"}

  context "as the account owner" do
    scenario "Updating an account" do
      visit root_url
      fill_in "Email", :with => account.owner.email
      fill_in "Password", :with => "password"
      click_button "Sign In"
      click_link "Edit Account"
      fill_in "Name", with: "A new name"
      sign_in_as(user:account.owner, account: account)
      click_button "Update Account"
      page.should have_content("Account updated successfully.")
      account.reload.name.should == "A new name"
    end
  end
end