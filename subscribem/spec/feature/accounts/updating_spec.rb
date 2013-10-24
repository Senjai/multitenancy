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

      let(:query_string) do
        Rack::Utils.build_query(
          plan_id: extreme_plan.id,
          http_status: 200,
          id: "a_fake_id",
          kind: "create_customer",
          hash: "8bb5b10a27f828afef46d033cb4ac900bc3653fd")
      end

      before do
        account.update_column(:plan_id, starter_plan.id)
      end

      scenario "updating an accounts plan" do
        subscription_params = {
          payment_method_token: "abcdef",
          plan_id: extreme_plan.braintree_id
        }
        subscription_results = double(success?: true, subscription: double(id: "abc123"))

        Braintree::Subscription
          .should_receive(:create)
          .with(subscription_params)
          .and_return(subscription_results)

        mock_transparent_redirect_response = double(success?: true)
        mock_transparent_redirect_response.stub_chain(:customer, :credit_cards)
          .and_return([double(token: "abcdef")])

        Braintree::TransparentRedirect
          .should_receive(:confirm)
          .with(query_string)
          .and_return(mock_transparent_redirect_response)

        click_link "Edit Account"
        select 'Extreme', from: 'Plan'
        click_button "Update Account"

        page.should have_content("Account updated successfully.")
        plan_url = subscribem.plan_account_url(plan_id: extreme_plan.id, subdomain: account.subdomain)
        page.current_url.should eql(plan_url)

        page.should have_content("You are changing to the 'Extreme' plan")
        page.should have_content("This plan costs $19.95 per month.")

        fill_in "Credit card number", :with => "4111111111111111"
        fill_in "Name on card", :with => "Dummy user"
        future_date = "#{Time.now.month + 1}/#{Time.now.year + 1}"
        fill_in "Expiration date", :with => future_date
        fill_in "CVV", :with => "123"
        click_button "Change plan"

        page.should have_content("You have switched to the 'Extreme' plan.")
        page.current_url.should == root_url + "/"
        account.reload.braintree_subscription_id.should == "abc123"
      end

      scenario "can't change accounts plans with invalid credit card number" do
        message = "Credit card number must be 12-19 digits"
        result = double(:success? => false, message: message)
        Braintree::TransparentRedirect
          .should_receive(:confirm)
          .with(query_string)
          .and_return(result)

        click_link "Edit Account"
        select 'Extreme', from: 'Plan'
        click_button "Update Account"

        page.should have_content("Account updated successfully.")
        plan_url = subscribem.plan_account_url(plan_id: extreme_plan.id, subdomain: account.subdomain)
        page.current_url.should eql(plan_url)

        page.should have_content("You are changing to the 'Extreme' plan")
        page.should have_content("This plan costs $19.95 per month.")

        fill_in "Credit card number", :with => "1"
        fill_in "Name on card", :with => "Dummy user"
        future_date = "#{Time.now.month + 1}/#{Time.now.year + 1}"
        fill_in "Expiration date", :with => future_date
        fill_in "CVV", :with => "123"
        click_button "Change plan"

        page.should have_content("Invalid credit card details. Please try again.")
        page.should have_content("Credit card number must be 12-19 digits")
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