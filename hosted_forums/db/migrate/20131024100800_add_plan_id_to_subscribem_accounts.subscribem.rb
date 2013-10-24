# This migration comes from subscribem (originally 20131024072122)
class AddPlanIdToSubscribemAccounts < ActiveRecord::Migration
  def change
    add_column :subscribem_accounts, :plan_id, :integer
  end
end
