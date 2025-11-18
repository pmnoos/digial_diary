class AddUserIdToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :user_id, :integer
  end
end
