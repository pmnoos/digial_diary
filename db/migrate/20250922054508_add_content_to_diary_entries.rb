class AddContentToDiaryEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :diary_entries, :content, :text
  end
end
