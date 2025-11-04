class RemindersController < ApplicationController
  before_action :authenticate_user!

  def index
    @upcoming_reminders = current_user.events
                                     .where('reminder_time >= ?', Time.current)
                                     .where('reminder_time <= ?', 7.days.from_now)
                                     .order(:reminder_time)
    
    @overdue_reminders = current_user.events
                                    .where('reminder_time < ?', Time.current)
                                    .where('start_time > ?', Time.current)
                                    .order(:reminder_time)
    
    @today_reminders = current_user.events
                                  .where(reminder_time: Date.current.beginning_of_day..Date.current.end_of_day)
                                  .order(:reminder_time)
  end

  def dismiss
    @event = current_user.events.find(params[:id])
    # You could add a 'dismissed' boolean column to events table if needed
    # For now, we'll just redirect back
    redirect_to reminders_path, notice: 'Reminder acknowledged.'
  end

  def snooze
    @event = current_user.events.find(params[:id])
    snooze_minutes = params[:minutes].to_i || 15
    
    if @event.update(reminder_time: @event.reminder_time + snooze_minutes.minutes)
      redirect_to reminders_path, notice: "Reminder snoozed for #{snooze_minutes} minutes."
    else
      redirect_to reminders_path, alert: 'Failed to snooze reminder.'
    end
  end
end