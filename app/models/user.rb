class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :diary_entries, dependent: :destroy
<<<<<<< HEAD

  # Subscription statuses
  SUBSCRIPTION_STATUSES = %w[trial active expired cancelled].freeze
  SUBSCRIPTION_PLANS = %w[free_trial monthly yearly].freeze

  validates :subscription_status, inclusion: { in: SUBSCRIPTION_STATUSES }
  validates :subscription_plan, inclusion: { in: SUBSCRIPTION_PLANS }

  # Set trial period when user signs up
  after_create :start_trial_period

  # Subscription methods
  def trial_active?
    subscription_status == 'trial' && trial_ends_at && trial_ends_at > Time.current
  end

  def subscription_active?
    subscription_status == 'active'
  end

  def can_access_app?
    trial_active? || subscription_active?
  end

  def trial_expired?
    subscription_status == 'trial' && trial_ends_at && trial_ends_at <= Time.current
  end

  def days_left_in_trial
    return 0 unless trial_ends_at
    [(trial_ends_at.to_date - Date.current).to_i, 0].max
  end

  def trial_percentage_used
    return 100 unless trial_started_at && trial_ends_at
    
    total_days = (trial_ends_at - trial_started_at) / 1.day
    used_days = (Time.current - trial_started_at) / 1.day
    
    [(used_days / total_days * 100).round, 100].min
  end

  # Check if user can create more entries (limit for trial)
  def can_create_entry?
    return true if subscription_active?
    return false unless trial_active?
    
    # Limit trial users to 50 entries
    diary_entries.count < 50
  end

  def remaining_trial_entries
    return 0 unless trial_active?
    [50 - diary_entries.count, 0].max
  end

  private

  def start_trial_period
    self.update_columns(
      trial_started_at: Time.current,
      trial_ends_at: 30.days.from_now,
      subscription_status: 'trial'
    )
  end
end
=======
 
  # ...existing code...
  has_many :events, dependent: :destroy
end
 
>>>>>>> 0ee28b8 (feat: add event reminders, plans, and Stripe integration scaffolding)
