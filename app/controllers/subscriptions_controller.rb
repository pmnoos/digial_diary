class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: [:pricing]

  def index
    @user = current_user
    if @user.respond_to?(:trial_percentage_used)
      @trial_progress    = @user.trial_percentage_used
      @days_remaining    = @user.days_left_in_trial
      @entries_remaining = @user.remaining_trial_entries
    end
  end

  def pricing
  end

  def change_plan
    plan = params[:plan].to_s
    return redirect_to subscriptions_path, alert: "Invalid plan." unless %w[monthly yearly].include?(plan)

    current_user.update!(subscription_plan: plan, subscription_status: "active")
    redirect_to subscriptions_path, notice: "Plan updated to #{plan.humanize}."
  end

  def upgrade
    plan = params[:plan].to_s
    return redirect_to pricing_subscriptions_path, alert: "Please select a valid plan." unless %w[monthly yearly].include?(plan)

    current_user.update!(subscription_status: "active", subscription_plan: plan)
    redirect_to subscriptions_path, notice: "Successfully upgraded to #{plan.humanize} plan!"
  end

  def cancel
    current_user.update!(subscription_status: "cancelled", subscription_plan: nil)
    redirect_to subscriptions_path, notice: "Subscription cancelled."
  end

  def resume
    current_user.update!(subscription_status: "active")
    redirect_to subscriptions_path, notice: "Subscription resumed."
  end

  def demo_mode
    current_user.update!(
      subscription_status: "trial",
      trial_started_at: Time.current,
      trial_ends_at: 30.days.from_now
    )
    redirect_to subscriptions_path, notice: "Trial extended for 30 days."
  end
end