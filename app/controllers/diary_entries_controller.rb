  # GET /diary_entries/archive
  def archive
    @archive = ... # your logic here
    @archive ||= []
  end
class DiaryEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_subscription_access, except: [:show, :index]
  before_action :check_entry_limit, only: [:new, :create]
  before_action :set_diary_entry, only: %i[show edit update destroy destroy_image]
   # Only gate creating new content; allow index/show/edit/update/destroy
  skip_before_action :check_subscription_access, raise: false
  before_action :check_subscription_access, only: [:new, :create]
  # GET /diary_entries
  def index
    if user_signed_in?
      @diary_entries = current_user.diary_entries.includes(:images_attachments)

      if params[:year].present?
        year = params[:year].to_i
        @diary_entries = @diary_entries.where(entry_date: Date.new(year, 1, 1)..Date.new(year, 12, 31))
      end

      if params[:search].present?
        @diary_entries = @diary_entries.where(
          "diary_entries.title ILIKE ? OR diary_entries.content ILIKE ?",
          "%#{params[:search]}%", "%#{params[:search]}%"
        )
      end

      @diary_entries = @diary_entries.order(entry_date: :desc).page(params[:page]).per(12)
      @available_years = current_user.diary_entries
                                     .where.not(entry_date: nil)
                                     .distinct
                                     .pluck(Arel.sql("EXTRACT(YEAR FROM entry_date)"))
                                     .compact
                                     .sort
                                     .reverse
    else
      @demo_mode = true
      demo_user = User.find_by(username: 'DemoUser')
      if demo_user.nil?
        redirect_to new_user_registration_path, alert: "Demo data not available. Please sign up to try the app!" and return
      end

      @diary_entries = DiaryEntry.joins(:user)
                                 .where(users: { username: 'DemoUser' })
                                 .includes(:images_attachments)

      if params[:year].present?
        year = params[:year].to_i
        @diary_entries = @diary_entries.where(entry_date: Date.new(year, 1, 1)..Date.new(year, 12, 31))
      end

      if params[:search].present?
        @diary_entries = @diary_entries.where(
          "diary_entries.title ILIKE ? OR diary_entries.content ILIKE ?",
          "%#{params[:search]}%", "%#{params[:search]}%"
        )
      end

      @diary_entries = @diary_entries.order(entry_date: :desc).page(params[:page]).per(12)
      @available_years = DiaryEntry.joins(:user)
                                   .where(users: { username: 'DemoUser' })
                                   .where.not(entry_date: nil)
                                   .distinct
                                   .pluck(Arel.sql("EXTRACT(YEAR FROM entry_date)"))
                                   .compact
                                   .sort
                                   .reverse
    end
  end

  # GET /diary_entries/:id
  def show
    @thought_of_the_day = Thought.where(mood: @diary_entry.mood).order(Arel.sql("RANDOM()")).first ||
                          Thought.order(Arel.sql("RANDOM()")).first
  end
    # GET /diary_entries/archive
    def archive
      @archive ||= []
      # Add your logic here to populate @archive
    end

  # GET /diary_entries/new
  def new
    @diary_entry = current_user.diary_entries.new(status: "draft")
    @thought_of_the_day = Thought.where(mood: %w[calm encouraging motivational positive hopeful reflective peaceful joyful])
                                 .order(Arel.sql("RANDOM()")).first || Thought.order(Arel.sql("RANDOM()")).first
  end

  # GET /diary_entries/:id/edit
  def edit; end

  # POST /diary_entries
  def create
    @diary_entry = current_user.diary_entries.new(diary_entry_params)
    if @diary_entry.save
      redirect_to @diary_entry, notice: "Entry created successfully!"
    else
      @thought_of_the_day = Thought.where(mood: %w[calm encouraging motivational positive hopeful reflective peaceful joyful])
                                   .order(Arel.sql("RANDOM()")).first || Thought.order(Arel.sql("RANDOM()")).first
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /diary_entries/:id
  def update
    if @diary_entry.update(diary_entry_params)
      redirect_to diary_entries_path, notice: "Entry updated successfully!"
    else
      @thought_of_the_day = Thought.where(mood: %w[calm encouraging motivational positive hopeful reflective peaceful joyful])
                                   .order(Arel.sql("RANDOM()")).first || Thought.order(Arel.sql("RANDOM()")).first
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /diary_entries/:id
  def destroy
    @diary_entry.destroy!
    redirect_to diary_entries_path, status: :see_other, notice: "Diary entry was successfully deleted."
  end

  # DELETE /diary_entries/:id/image/:image_id
  def destroy_image
    attachment = @diary_entry.images.attachments.find_by(id: params[:image_id])
    if attachment
      attachment.purge
      redirect_to edit_diary_entry_path(@diary_entry), notice: "Image deleted."
    else
      redirect_to edit_diary_entry_path(@diary_entry), alert: "Image not found."
    end
  end

  private


  def check_subscription_access
    return if current_user&.can_access_app?
    redirect_to pricing_subscriptions_path, alert: "Your trial has expired. Please upgrade to continue."
  end
end
  def set_diary_entry
    if current_user
      @diary_entry = current_user.diary_entries.find(params[:id])
    else
      demo_user = User.find_by(username: "DemoUser")
      @diary_entry = demo_user&.diary_entries&.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to diary_entries_path, alert: "Diary entry not found or you don't have permission to access it."
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
      :title, :content, :entry_date, :status, :mood, :thought_id,
      images: [], tag_list: [], tag_ids: []
    )
  end
