require 'spec_helper'
require 'subscribem/testing_support/factories/accounts_factory'
require 'subscribem/testing_support/factories/users_factory'
require 'subscribem/testing_support/authentication_helpers'

feature "Forum Scoping" do
  include Subscribem::TestingSupport::AuthenticationHelpers

  let!(:account_a) {FactoryGirl.create(:account_with_schema)}
  let!(:account_b) {FactoryGirl.create(:account_with_schema)}

  def create_forum(name)
    category = Forem::Category.create(name: "A category")
    forum = Forem::Forum.new
    forum.name = name
    forum.description = "A forum"
    forum.category = category
    forum.save!
  end

  before do
    Apartment::Database.switch(account_a.subdomain)
    create_forum("Account A's Forum")
    Apartment::Database.switch(account_b.subdomain)
    create_forum("Account B's Forum")
    Apartment::Database.reset
  end

  scenario "Displays only account a's forums" do
    sign_in_as(user: account_a.owner, account: account_a)
    visit "http://#{account_a.subdomain}.example.com"
    page.should have_content("Account A's Forum")
    page.should_not have_content("Account B's Forum")
  end

  scenario "Displays only account b's forums" do
    sign_in_as(user: account_b.owner, account: account_b)
    visit "http://#{account_b.subdomain}.example.com"
    page.should have_content("Account B's Forum")
    page.should_not have_content("Account A's Forum")
  end
end