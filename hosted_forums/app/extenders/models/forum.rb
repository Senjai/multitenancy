Forem::Forum.class_eval do
  validate :check_plan_limit
  def check_plan_limit
    current_schema = Apartment::Database.current
    account = Subscribem::Account.find_by_subdomain!(current_schema)
    plan_limit = Subscribem::Plan::LIMITS[account.plan.try(:name)]
    if plan_limit && Forem::Forum.count == plan_limit
      errors.add("base", "You are not allowed to create more than" +
      " #{plan_limit} forums on your current plan.")
    end
  end
end