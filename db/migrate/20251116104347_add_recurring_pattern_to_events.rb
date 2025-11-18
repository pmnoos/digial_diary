class AddRecurringPatternToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :recurring_pattern, :string
  end
end
