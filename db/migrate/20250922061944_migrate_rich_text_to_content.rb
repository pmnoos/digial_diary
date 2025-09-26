class MigrateRichTextToContent < ActiveRecord::Migration[8.0]
  def up
    # Copy rich text content to the new text field
    ActionText::RichText.where(record_type: 'DiaryEntry', name: 'content').find_each do |rich_text|
      diary_entry = DiaryEntry.find(rich_text.record_id)
      if diary_entry && rich_text.body.present?
        # Convert rich text to plain text
        plain_text = rich_text.body.to_plain_text
        diary_entry.update_column(:content, plain_text)
        puts "Migrated content for DiaryEntry #{diary_entry.id}"
      end
    end
  end

  def down
    # This migration is not easily reversible
    # The rich text data would need to be reconstructed
    raise ActiveRecord::IrreversibleMigration
  end
end
