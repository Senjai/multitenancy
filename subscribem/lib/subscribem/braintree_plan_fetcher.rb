class BraintreePlanFetcher
  def self.store_locally
    Braintree::Plan.all.each do |plan|
      Subscribem::Plan.create({
        name: plan.name,
        price: plan.price,
        braintree_id: plan.id
      })
    end
  end
end