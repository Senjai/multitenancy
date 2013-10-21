require 'spec_helper'

describe Subscribem::Account do
  it "can be created with an owner" do
    params = {
      name: "Test Account",
      subdomain: "test",
      owner_attributes: {
        email: "user@example.com",
        password: "password",
        password_confirmation: "password"
      }
    }

    account = Subscribem::Account.create_with_owner(params)

    account.should be_persisted
    account.users.first.should == account.owner
  end
end