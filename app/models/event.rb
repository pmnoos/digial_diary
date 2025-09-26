class Event < ApplicationRecord
  validates :title, :start_time, presence: true
 scope :upcoming, -> { where("start_time >= ?", Time.current).order(:start_time) }
end
