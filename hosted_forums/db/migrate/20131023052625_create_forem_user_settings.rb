class CreateForemUserSettings < ActiveRecord::Migration
  def change
    create_table :forem_user_settings do |t|
      t.boolean :forem_admin, default: false
      t.boolean :forem_auto_subscribe, default: true
      t.string :forem_state, default: "pending_review"
      t.references :user
    end
  end
end
