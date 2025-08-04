class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  
  def index
    # Show demo content for visitors
    if user_signed_in?
      # Logged in users see their dashboard
      redirect_to diary_entries_path
    else
      # Visitors see demo content
      @demo_entries = DiaryEntry.joins(:user)
                                .where(users: { username: 'DemoUser' })
                                .includes(:images_attachments)
                                .order(entry_date: :desc)
                                .limit(6)
      
      @total_demo_entries = DiaryEntry.joins(:user).where(users: { username: 'DemoUser' }).count
    end
  end
end
