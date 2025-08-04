class DiaryEntriesController < ApplicationController
  before_action :set_diary_entry, only: %i[show edit update destroy]
  before_action :check_subscription_access, except: [:show]
  before_action :check_entry_limit, only: [:new, :create]

  def index
    @diary_entries = current_user.diary_entries.includes(:images_attachments)

    # Filter by year if specified
    if params[:year].present?
      year = params[:year].to_i
      @diary_entries = @diary_entries.where(entry_date: Date.new(year, 1, 1)..Date.new(year, 12, 31))
    end

    # Search functionality
    if params[:search].present?
      @diary_entries = @diary_entries.joins(:content).where(
        "diary_entries.title ILIKE ? OR action_text_rich_texts.body ILIKE ?",
        "%#{params[:search]}%", "%#{params[:search]}%"
      )
    end

    @diary_entries = @diary_entries.order(entry_date: :desc).page(params[:page]).per(12)

    # Get available years for filter dropdown
    @available_years = current_user.diary_entries.distinct.pluck(Arel.sql("EXTRACT(YEAR FROM entry_date)")).sort.reverse
  end

  def show
    @thought_of_the_day = Thought.where(mood: @diary_entry.mood)
                                 .order(Arel.sql("RANDOM()")).first ||
                          Thought.order(Arel.sql("RANDOM()")).first
  end

  def new
    @diary_entry = DiaryEntry.new(status: "draft")

    @thought_of_the_day = Thought.where(mood: %w[calm encouraging motivational positive hopeful reflective peaceful joyful])
                                 .order(Arel.sql("RANDOM()")).first || Thought.order(Arel.sql("RANDOM()")).first
  end

  def edit
  end

  def create
    @diary_entry = current_user.diary_entries.new(diary_entry_params)
    if @diary_entry.save
      redirect_to @diary_entry, notice: "Entry created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @diary_entry = current_user.diary_entries.find(params[:id])
    if @diary_entry.update(diary_entry_params)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("autosave-status", partial: "diary_entries/saved_indicator") }
        format.html { redirect_to @diary_entry, notice: "Saved!" }
      end
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @diary_entry.destroy!
    respond_to do |format|
      format.html { redirect_to diary_entries_path, status: :see_other, notice: "Diary entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def archive
    entries = current_user.diary_entries.published.order(entry_date: :desc)
    @archive = entries.group_by { |e| e.entry_date.beginning_of_month }
  end

  private

  def set_diary_entry
    @diary_entry = current_user.diary_entries.find(params[:id])
  end

  def check_subscription_access
    unless current_user.can_access_app?
      redirect_to pricing_subscriptions_path, alert: "Your trial has expired. Please upgrade to continue using Digital Diary."
    end
  end

  def check_entry_limit
    unless current_user.can_create_entry?
      if current_user.trial_active?
        redirect_to subscriptions_path, alert: "You've reached the limit of 50 entries for your trial. Upgrade to create unlimited entries!"
      else
        redirect_to pricing_subscriptions_path, alert: "Please upgrade your subscription to create new entries."
      end
    end
  end

  def diary_entry_params
    params.require(:diary_entry).permit(
      :title,
      :content,
      :entry_date,
      :status,
      :mood,
      images: [],
      tag_list: [],
      tag_ids: []
    )
  end
end
