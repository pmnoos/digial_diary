class AddSubscriptionToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :trial_started_at, :datetime
    unless column_exists?(:users, :trial_ends_at)
      add_column :users, :trial_ends_at, :datetime
    end
    add_column :users, :subscription_status, :string, default: 'trial'
    add_column :users, :subscription_plan, :string, default: 'free_trial'
    add_column :users, :payment_id, :string
    
  #  add_index :users, :subscription_status
    
  end
end
