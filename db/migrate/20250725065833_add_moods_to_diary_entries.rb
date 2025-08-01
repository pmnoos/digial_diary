class AddMoodsToDiaryEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :diary_entries, :moods, :string
  end
end
