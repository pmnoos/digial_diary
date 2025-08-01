class CreateThoughts < ActiveRecord::Migration[8.0]
  def change
    create_table :thoughts do |t|
      t.text :content
      t.string :mood

      t.timestamps
    end
  end
end
