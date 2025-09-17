class DiaryEntry < ApplicationRecord
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
    attachable.variant :medium, resize_to_limit: [600, 600]
    attachable.variant :large, resize_to_limit: [1200, 1200]
  end
  
  belongs_to :user
  belongs_to :thought, optional: true
  has_rich_text :content

  has_many :diary_entry_tags, dependent: :destroy
  has_many :tags, through: :diary_entry_tags

  validates :title, presence: true
  validates :entry_date, presence: true
  validates :status, inclusion: { in: %w[draft published] }
  validate :acceptable_images

  # Set default status
  after_initialize :set_defaults
  
  # Process images after saving
  after_create :process_images_async

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

  def process_images_async
    return unless images.attached?
    
    images.each do |image|
      ImageProcessingJob.perform_later(image.id) if image.blob.image?
    end
  end
end
