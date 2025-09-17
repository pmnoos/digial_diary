class Event < ApplicationRecord
  validates :title, :event_date, presence: true
  scope :upcoming, -> { where("event_date >= ?", Time.current).order(:event_date) }
end