class DiaryEntry < ApplicationRecord
  has_many_attached :images
  belongs_to :user
  has_rich_text :content

  has_many :diary_entry_tags, dependent: :destroy
  has_many :tags, through: :diary_entry_tags

  validates :title, presence: true
  validates :status, inclusion: { in: %w[draft published] }

  scope :published, -> { where(status: "published") }
  scope :by_month_year, -> {
    all.group_by { |entry| entry.entry_date.beginning_of_month }
  }
end



  