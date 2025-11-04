class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]

 def index
  @events = current_user.events.order(:start_time)
  end

  def show
  end

  def new
    @event = current_user.events.build
  end

  def create
    @event = current_user.events.build(event_params)
    
    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: 'Event was successfully deleted.'
  end

  private

  def set_event
    @event = current_user.events.find(params[:id])
  end

  def event_params
    # Fixed: use the actual column names from your table
    params.require(:event).permit(:title, :description, :start_time, :end_time, :location, :reminder_time, :recurring_pattern)
  end
end