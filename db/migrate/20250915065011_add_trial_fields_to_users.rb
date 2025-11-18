class AddTrialFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
 # Duplicate add_column for :trial_ends_at removed; already exists from previous migration
#  add_column :users, :entry_limit, :integer
  end
end
