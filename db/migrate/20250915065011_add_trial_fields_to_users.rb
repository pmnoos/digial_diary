class AddTrialFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :trial_ends_at, :datetime
    add_column :users, :entry_limit, :integer
  end
end
