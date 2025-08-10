class DiaryEntriesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_diary_entry, only: %i[show edit update destroy]
  before_action :check_subscription_access, except: [:show, :index]
  before_action :check_entry_limit, only: [:new, :create]

  def index
    if user_signed_in?
      # Logged in users see their own entries
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

      # Get available years for filter dropdown
      @available_years = current_user.diary_entries.where.not(entry_date: nil).distinct.pluck(Arel.sql("EXTRACT(YEAR FROM entry_date)")).compact.sort.reverse
    else
      # Visitors see demo entries
      @demo_mode = true
      
      # Check if DemoUser exists
      demo_user = User.find_by(username: 'DemoUser')
      if demo_user.nil?
        # Fallback: redirect to sign up if no demo data available
        redirect_to new_user_registration_path, 
                    alert: "Demo data not available. Please sign up to try the app!"
        return
      end
      
      @diary_entries = DiaryEntry.joins(:user)
                                 .where(users: { username: 'DemoUser' })
                                 .includes(:images_attachments)
      
      # Filter by year if specified
      if params[:year].present?
        year = params[:year].to_i
        @diary_entries = @diary_entries.where(entry_date: Date.new(year, 1, 1)..Date.new(year, 12, 31))
      end

      # Search functionality for demo entries
      if params[:search].present?
        @diary_entries = @diary_entries.joins("LEFT JOIN action_text_rich_texts ON action_text_rich_texts.record_type = 'DiaryEntry' AND action_text_rich_texts.record_id = diary_entries.id AND action_text_rich_texts.name = 'content'").where(
          "diary_entries.title ILIKE ? OR action_text_rich_texts.body ILIKE ?",
          "%#{params[:search]}%", "%#{params[:search]}%"
        )
      end
      
      @diary_entries = @diary_entries.order(entry_date: :desc)
                                     .page(params[:page]).per(12)
      
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
    @diary_entry = DiaryEntry.new(status: "draft")

    @thought_of_the_day = Thought.where(mood: %w[calm encouraging motivational positive hopeful reflective peaceful joyful])
                                 .order(Arel.sql("RANDOM()")).first || Thought.order(Arel.sql("RANDOM()")).first
  end

  def edit
  end

  def create
    @diary_entry = current_user.diary_entries.new(diary_entry_params)
    
    if @diary_entry.save
      # Process images in the background if they were uploaded
      if @diary_entry.images.attached?
        begin
          # Pre-generate variants to catch any processing errors early
          @diary_entry.images.each do |image|
            image.variant(:thumb) if image.blob.content_type.in?(%w[image/jpeg image/jpg image/png image/gif image/webp])
          end
          flash[:notice] = "Entry created successfully!"
        rescue => e
          Rails.logger.error "Image processing warning: #{e.message}"
          flash[:notice] = "Entry created! Some images may need time to process."
        end
      else
        flash[:notice] = "Entry created!"
      end
      
      redirect_to @diary_entry
    else
      @thought_of_the_day = Thought.where(mood: %w[calm encouraging motivational positive hopeful reflective peaceful joyful])
                                   .order(Arel.sql("RANDOM()")).first || Thought.order(Arel.sql("RANDOM()")).first
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @diary_entry = current_user.diary_entries.find(params[:id])
    
    if @diary_entry.update(diary_entry_params)
      # Handle image processing with error handling
      if @diary_entry.images.attached?
        begin
          # Pre-generate image variants to catch any processing errors early
          @diary_entry.images.each do |image|
            image.variant(:thumb).processed
          end
          flash[:notice] = "Entry updated successfully!"
        rescue => e
          Rails.logger.error "Image processing warning: #{e.message}"
          flash[:notice] = "Entry updated! Some images may need time to process."
        end
      else
        flash[:notice] = "Entry updated successfully!"
      end
      
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("autosave-status", partial: "diary_entries/saved_indicator") }
        format.html { redirect_to @diary_entry, notice: flash[:notice] }
        format.json { render :show, status: :ok, location: @diary_entry }
      end
    else
      @thought_of_the_day = Thought.where(mood: %w[calm encouraging motivational positive hopeful reflective peaceful joyful])
                                   .order(Arel.sql("RANDOM()")).first || Thought.order(Arel.sql("RANDOM()")).first
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @diary_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @diary_entry = current_user.diary_entries.find(params[:id])
    @diary_entry.destroy!
    respond_to do |format|
      format.html { redirect_to diary_entries_path, status: :see_other, notice: "Diary entry was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def archive
    entries = current_user.diary_entries.published.order(entry_date: :desc)
    @archive = entries.group_by { |e| e.entry_date.beginning_of_month }
  end

  # DELETE /diary_entries/:id/remove_image
  def remove_image
    @diary_entry = current_user.diary_entries.find(params[:id])
    image = @diary_entry.images.find(params[:image_id])
    
    if image
      image.purge
      flash[:notice] = "Image deleted successfully."
    else
      flash[:alert] = "Image not found."
    end
    
    # Redirect back to where they came from, or show page as fallback
    redirect_back(fallback_location: diary_entry_path(@diary_entry))
  end

  private

  def set_diary_entry
    if current_user
      @diary_entry = current_user.diary_entries.find(params[:id])
    else
      # For visitors in demo mode, find entry from demo user
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
      images: [],
      tag_list: [],
      tag_ids: []
    )
  end
end
