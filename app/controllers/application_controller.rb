class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  def demo_login
    # Find or create demo user for instant access
    demo_user = User.find_by(email: 'demo@digitaldiaryapp.com')
    
    if demo_user
      sign_in(demo_user)
      redirect_to diary_entries_path, notice: '🎉 Welcome to the demo! Explore all features with sample data.'
    else
      redirect_to root_path, alert: 'Demo account not available. Please try again later.'
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username, :subscription_plan ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username, :subscription_plan ])
  end
end