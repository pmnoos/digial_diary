class Tag < ApplicationRecord
    has_many :diary_entry_tags, dependent: :destroy
    has_many :diary_entries, through: :diary_entry_tags
  
    validates :name, presence: true, uniqueness: true
  end
  