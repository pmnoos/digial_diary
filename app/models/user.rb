class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :diary_entries, dependent: :destroy
  has_many :events, dependent: :destroy

  # Subscription enums/validations
  SUBSCRIPTION_STATUSES = %w[trial active expired cancelled].freeze
  SUBSCRIPTION_PLANS    = %w[monthly yearly].freeze

  # Ensure defaults exist before validations on create
  before_validation :set_initial_trial, on: :create

  validates :subscription_status, inclusion: { in: SUBSCRIPTION_STATUSES }
  validates :subscription_plan, inclusion: { in: SUBSCRIPTION_PLANS }

  # Public helpers (used by views/controllers)
  def subscription_active?
    subscription_status == "active"
  end

  def trial_active?
    subscription_status == "trial" && (trial_ends_at.blank? || trial_ends_at.future?)
  end

  def trial_expired?
    subscription_status == "trial" && trial_ends_at.present? && trial_ends_at.past?
  end

  def days_left_in_trial
    return 0 unless trial_ends_at
    [(trial_ends_at.to_date - Date.current).to_i, 0].max
  end

  def trial_percentage_used
    return 100 unless trial_started_at && trial_ends_at
    total_days = (trial_ends_at - trial_started_at) / 1.day
    return 100 if total_days <= 0
    used_days = (Time.current - trial_started_at) / 1.day
    [(used_days / total_days * 100).round, 100].min
  end

  def remaining_trial_entries
    return 0 unless trial_active?
    [50 - diary_entries.count, 0].max
  end

  def can_access_app?
    subscription_active? || trial_active?
  end
  def can_create_entry?
    subscription_status == 'active' || (trial_active? && remaining_trial_entries > 0)
  end
  
  private

  def set_initial_trial
    self.subscription_status ||= "trial"
    self.subscription_plan   ||= "monthly" # default plan for new users
    self.trial_started_at   ||= Time.current
    self.trial_ends_at      ||= 30.days.from_now
  end
end