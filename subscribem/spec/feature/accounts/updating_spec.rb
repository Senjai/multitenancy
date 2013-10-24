require 'spec_helper'
require 'subscribem/testing_support/factories/accounts_factory'
require 'subscribem/testing_support/factories/users_factory'
require 'subscribem/testing_support/authentication_helpers'

feature "Accounts" do
  include Subscribem::TestingSupport::AuthenticationHelpers
  let!(:account) {FactoryGirl.create(:account_with_schema)}
  let(:root_url) {"http://#{account.subdomain}.example.com"}

  context "as the account owner" do
    before do
      visit root_url
      fill_in "Email", :with => account.owner.email
      fill_in "Password", :with => "password"
      click_button "Sign In"
    end

    scenario "Updating an account" do
      click_link "Edit Account"
      fill_in "Name", with: "A new name"
      sign_in_as(user:account.owner, account: account)
      click_button "Update Account"
      page.should have_content("Account updated successfully.")
      account.reload.name.should == "A new name"
    end

    scenario "updating an account with invalid datasz" do
      click_link "Edit Account"
      fill_in "Name", with: ""
      click_button "Update Account"

      page.should have_content("Name can't be blank")
      page.should have_content("Account could not be updated.")
    end

    context "with plans" do
      let!(:starter_plan) do
        Subscribem::Plan.create(
          name: 'Starter',
          price: 9.95,
          braintree_id: 'starter'
        )
      end

      let!(:extreme_plan) do
        Subscribem::Plan.create(
          name: 'Extreme',
          price: 19.95,
          braintree_id: 'extreme'
        )
      end

      before do
        account.update_column(:plan_id, starter_plan.id)
      end

      scenario "updating an accounts plan" do
        click_link "Edit Account"
        select 'Extreme', from: 'Plan'
        click_button "Update Account"

        page.should have_content("Account updated successfully.")
        page.should have_content("You are now on the 'Extreme' plan.")
        account.reload.plan.should == extreme_plan
      end
    end
  end

  context "As a user" do
    before do
      user = FactoryGirl.create(:user)
      sign_in_as(user: user)
    end

    scenario "cannot edit an accounts information" do
      visit subscribem.edit_account_url(subdomain: account.subdomain)
      page.should have_content("You are not allowed to do that.")
    end
  end
end