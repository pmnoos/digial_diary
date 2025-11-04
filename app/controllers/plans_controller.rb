class PlansController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  
  def index
  end

  def checkout
    plan = params[:plan] # "pro" or "premium"
    # Here you would integrate with Stripe or your payment provider
    # For now, just simulate a successful purchase:
    if plan == "pro"
      # Upgrade user to pro
      current_user.update(plan: "pro")
      redirect_to root_path, notice: "You have upgraded to Pro!"
    elsif plan == "premium"
      # Upgrade user to premium
      current_user.update(plan: "premium")
      redirect_to root_path, notice: "You have upgraded to Premium!"
    else
      redirect_to plans_path, alert: "Invalid plan."
    end
  end
end