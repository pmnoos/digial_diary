class AddThoughtIdToDiaryEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :diary_entries, :thought_id, :integer
  end
end
