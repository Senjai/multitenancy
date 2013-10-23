require 'spec_helper'
require 'subscribem/braintree_plan_fetcher'

describe BraintreePlanFetcher do
  let(:faux_plan) do
    double('Plan',
           id: 'faux1',
           name: 'starter',
           price: '9.95')
  end

  it "fetches and stores plans" do
    Braintree::Plan.should_receive(:all).and_return([faux_plan])
    Subscribem::Plan.should_receive(:create).with({
      braintree_id: 'faux1',
      name: 'starter',
      price: '9.95'
    })
    BraintreePlanFetcher.store_locally
  end

  it "checks and updates plans" do
    Braintree::Plan.should_receive(:all).and_return([faux_plan])
    Subscribem::Plan.should_receive(:find_by_braintree_id)
                    .with(faux_plan.id)
                    .and_return(plan = double)
    plan.should_receive(:update_attributes).with({
      name: "starter",
      price: "9.95"
    })
    Subscribem::Plan.should_not_receive(:create)
    BraintreePlanFetcher.store_locally
  end
end