class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: [:pricing]

  def index
    @user = current_user
    @trial_progress = @user.trial_percentage_used
    @days_remaining = @user.days_left_in_trial
    @entries_remaining = @user.remaining_trial_entries
  end

  def pricing
    # Pricing information page - accessible to everyone
  end

  def upgrade
    # Handle subscription upgrade
    @user = current_user
    
    if params[:plan] == 'monthly'
      # In a real app, you'd integrate with Stripe, PayPal, etc.
      @user.update!(
        subscription_status: 'active',
        subscription_plan: 'monthly'
      )
      redirect_to subscriptions_path, notice: 'Successfully upgraded to Monthly plan!'
    elsif params[:plan] == 'yearly'
      @user.update!(
        subscription_status: 'active',
        subscription_plan: 'yearly'
      )
      redirect_to subscriptions_path, notice: 'Successfully upgraded to Yearly plan!'
    else
      redirect_to pricing_subscriptions_path, alert: 'Please select a valid plan.'
    end
  end

  def demo_mode
    # Allow users to extend demo/trial for testing
    if params[:extend_trial] && current_user.trial_expired?
      current_user.update!(
        trial_started_at: Time.current,
        trial_ends_at: 30.days.from_now,
        subscription_status: 'trial'
      )
      redirect_to root_path, notice: 'Trial extended for demonstration purposes!'
    end
  end

  # Helper method to refresh demo user trial (for development/testing)
  def refresh_demo_trial
    demo_user = User.find_by(email: 'demo@digitaldiaryapp.com')
    if demo_user
      demo_user.update!(
        trial_started_at: Time.current,
        trial_ends_at: 30.days.from_now,
        subscription_status: 'trial'
      )
      redirect_to root_path, notice: 'Demo user trial refreshed!'
    else
      redirect_to root_path, alert: 'Demo user not found!'
    end
  end
end
