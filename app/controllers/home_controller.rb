class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    # Show demo content for visitors
    if user_signed_in?
      # Logged in users see their dashboard with upcoming events
      @upcoming_events = current_user.events.where(start_time: Time.current..3.days.from_now).order(:start_time)
      redirect_to diary_entries_path
    else
      # Visitors see demo content
      demo_user = User.find_by(username: 'DemoUser')
      if demo_user
        @demo_entries = DiaryEntry.joins(:user)
                                  .where(users: { username: 'DemoUser' })
                                  .includes(:images_attachments)
                                  .order(entry_date: :desc)
                                  .limit(6)
        @total_demo_entries = DiaryEntry.joins(:user).where(users: { username: 'DemoUser' }).count
        
        # Also show demo events for visitors
        @demo_upcoming_events = demo_user.events.where(start_time: Time.current..3.days.from_now).order(:start_time) if demo_user.respond_to?(:events)
      else
        # No demo data available
        @demo_entries = []
        @total_demo_entries = 0
        @demo_upcoming_events = []
      end
    end
  end

  def test_editor
    @diary_entry = DiaryEntry.new
    render layout: 'application'
  end
end