class AddMoodToDiaryEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :diary_entries, :mood, :string
  end
end
