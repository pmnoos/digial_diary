class DiaryEntriesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_diary_entry, only: %i[show edit update destroy remove_image purge_image]
  before_action :check_subscription_access, except: [:show, :index]
  before_action :check_entry_limit, only: [:new, :create]

  def index
    if user_signed_in?
      @diary_entries = current_user.diary_entries.includes(:images_attachments)
      # Filter by year if specified
      if params[:year].present?
        year = params[:year].to_i
        @diary_entries = @diary_entries.where(entry_date: Date.new(year, 1, 1)..Date.new(year, 12, 31))
      end
      # Search functionality
      if params[:search].present?
        @diary_entries = @diary_entries.joins("LEFT JOIN action_text_rich_texts ON action_text_rich_texts.record_type = 'DiaryEntry' AND action_text_rich_texts.record_id = diary_entries.id AND action_text_rich_texts.name = 'content'").where(
          "diary_entries.title ILIKE ? OR action_text_rich_texts.body ILIKE ?",
          "%#{params[:search]}%", "%#{params[:search]}%"
        )
      end
      @diary_entries = @diary_entries.order(entry_date: :desc).page(params[:page]).per(12)
      @available_years = current_user.diary_entries.where.not(entry_date: nil).distinct.pluck(Arel.sql("EXTRACT(YEAR FROM entry_date)")).compact.sort.reverse
    else
      # Visitors see demo entries
      @demo_mode = true
      demo_user = User.find_by(username: 'DemoUser')
      if demo_user.nil?
        redirect_to new_user_registration_path, alert: "Demo data not available. Please sign up to try the app!"
        return
      end
      @diary_entries = DiaryEntry.joins(:user)
                                 .where(users: { username: 'DemoUser' })
                                 .includes(:images_attachments)
      if params[:year].present?
        year = params[:year].to_i
        @diary_entries = @diary_entries.where(entry_date: Date.new(year, 1, 1)..Date.new(year, 12, 31))
      end
      if params[:search].present?
        @diary_entries = @diary_entries.joins("LEFT JOIN action_text_rich_texts ON action_text_rich_texts.record_type = 'DiaryEntry' AND action_text_rich_texts.record_id = diary_entries.id AND action_text_rich_texts.name = 'content'").where(
          "diary_entries.title ILIKE ? OR action_text_rich_texts.body ILIKE ?",
          "%#{params[:search]}%", "%#{params[:search]}%"
        )
      end
      @diary_entries = @diary_entries.order(entry_date: :desc).page(params[:page]).per(12)
      @available_years = DiaryEntry.joins(:user)
                                   .where(users: { username: 'DemoUser' })
                                   .where.not(entry_date: nil)
                                   .distinct
                                   .pluck(Arel.sql("EXTRACT(YEAR FROM entry_date)"))
                                   .compact.sort.reverse
    end
  end

  def show
    @thought_of_the_day = Thought.where(mood: @diary_entry.mood)
                                 .order(Arel.sql("RANDOM()")).first ||
                          Thought.order(Arel.sql("RANDOM()")).first
  end

  def new
    @diary_entry = current_user.diary_entries.new(status: "draft")
    @thought_of_the_day = Thought.where(mood: %w[calm encouraging motivational positive hopeful reflective peaceful joyful])
                                 .order(Arel.sql("RANDOM()")).first || Thought.order(Arel.sql("RANDOM()")).first
  end

  def edit
  end

  def create
    @diary_entry = current_user.diary_entries.new(diary_entry_params)
    if @diary_entry.save
      flash[:notice] = "Entry created successfully!"
      redirect_to @diary_entry
    else
      @thought_of_the_day = Thought.where(mood: %w[calm encouraging motivational positive hopeful reflective peaceful joyful])
                                   .order(Arel.sql("RANDOM()")).first || Thought.order(Arel.sql("RANDOM()")).first
      render :new, status: :unprocessable_entity
    end
  end

def update
  if @diary_entry.update(diary_entry_params)
    flash[:notice] = "Entry updated successfully!"
    redirect_to diary_entries_path  # Changed from: redirect_to @diary_entry
  else
    @thought_of_the_day = Thought.where(mood: %w[calm encouraging motivational positive hopeful reflective peaceful joyful])
                               .order(Arel.sql("RANDOM()")).first || Thought.order(Arel.sql("RANDOM()")).first
    render :edit, status: :unprocessable_entity
  end
end

  def destroy
    @diary_entry.destroy!
    respond_to do |format|
      format.html { redirect_to diary_entries_path, status: :see_other, notice: "Diary entry was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def archive
    entries = current_user.diary_entries.published.order(entry_date: :desc)
    if params[:year].present?
      year = params[:year].to_i
      if params[:month].present?
        month = params[:month].to_i
        entries = entries.where(entry_date: Date.new(year, month, 1)..Date.new(year, month, -1))
      else
        entries = entries.where(entry_date: Date.new(year, 1, 1)..Date.new(year, 12, 31))
      end
    end
    case params[:group_by]
    when 'week'
      @archive = entries.group_by { |e| e.entry_date.beginning_of_week }
      @grouping = 'week'
    when 'year'
      @archive = entries.group_by { |e| e.entry_date.year }
      @grouping = 'year'
    else
      @archive = entries.group_by { |e| e.entry_date.beginning_of_month }
      @grouping = 'month'
    end
    @filter_year = params[:year].to_i if params[:year].present?
    @filter_month = params[:month].to_i if params[:month].present?
  end


  def remove_image
    image = @diary_entry.images.find(params[:image_id])
    if image
      image.purge
      flash[:notice] = "Image deleted successfully."
    else
      flash[:alert] = "Image not found."
    end
    redirect_back(fallback_location: diary_entry_path(@diary_entry))
  end

  def purge_image
    image = @diary_entry.images.find(params[:image_id])
    if image
      image.purge
      flash[:notice] = "Image deleted successfully."
    else
      flash[:alert] = "Image not found."
    end
    redirect_back(fallback_location: diary_entry_path(@diary_entry))
  end

  private

  def set_diary_entry
    if current_user
      @diary_entry = current_user.diary_entries.find(params[:id])
    else
      demo_user = User.find_by(username: 'DemoUser')
      if demo_user
        @diary_entry = demo_user.diary_entries.find(params[:id])
      else
        redirect_to diary_entries_path, alert: "Demo content not available"
      end
    end
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
      :thought_id,
      images: [],
      tag_list: [],
      tag_ids: []
    )
  end
end