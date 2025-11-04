class Event < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true
  validates :start_time, presence: true
  
  # Useful scopes using the correct column names
  scope :upcoming, -> { where('start_time >= ?', Time.current) }
  scope :past, -> { where('start_time < ?', Time.current) }
  scope :today, -> { where(start_time: Date.current.beginning_of_day..Date.current.end_of_day) }
end