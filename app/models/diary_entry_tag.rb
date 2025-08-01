class DiaryEntryTag < ApplicationRecord
  belongs_to :diary_entry
  belongs_to :tag
end
