class CreateDiaryEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :diary_entries do |t|
      t.string :title
      t.date :entry_date
      t.string :status

      t.timestamps
    end
  end
end
