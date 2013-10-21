require 'spec_helper'

feature "Account Scoping" do
  let!(:account_a) {FactoryGirl.create(:account)}
  let!(:account_b) {FactoryGirl.create(:account)}

  before do
    Thing.create(name: "Account A's Thing", account: account_a)
    Thing.create(name: "Account B's Thing", account: account_b)
  end

  scenario "Only displays Account A's records" do
    sign_in_as(user: account_a.owner, account: account_a)
    visit '/things'
    page.should have_content("Account A's Thing")
    page.should_not have_content("Account B's Thing")
  end

  scenario "Only displays Account B's records" do
    sign_in_as(user: account_b.owner, account: account_b)
    visit '/things'
    page.should have_content("Account B's Thing")
    page.should_not have_content("Account A's Thing")
  end
end

