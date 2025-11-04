class DiaryEntry < ApplicationRecord
  
  belongs_to :user
  has_many_attached :images
  belongs_to :thought, optional: true
  # Using simple text field instead of rich text for better reliability

  has_many :diary_entry_tags, dependent: :destroy
  has_many :tags, through: :diary_entry_tags

  validates :title, presence: true
  validates :entry_date, presence: true
  validates :status, inclusion: { in: %w[draft published] }
  validate :acceptable_images

  # Set default status
  after_initialize :set_defaults
  
  # Images are processed directly by Active Storage

  scope :published, -> { where(status: "published") }
  scope :by_month_year, -> {
    all.group_by { |entry| entry.entry_date.beginning_of_month }
  }

  private

  def set_defaults
    self.status ||= "draft"
    self.entry_date ||= Date.current
  end

  def acceptable_images
    return unless images.attached?

    images.each do |image|
      unless image.blob.content_type.in?(%w[image/jpeg image/jpg image/png image/gif image/webp])
        errors.add(:images, "must be a valid image format (JPEG, PNG, GIF, WebP)")
      end

      if image.blob.byte_size > 10.megabytes
        errors.add(:images, "must be less than 10MB")
      end
    end
  end

end
