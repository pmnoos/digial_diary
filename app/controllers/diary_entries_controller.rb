class DiaryEntriesController < ApplicationController
  before_action :set_diary_entry, only: %i[show edit update destroy]

  def index
    @diary_entries = current_user.diary_entries.order(entry_date: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @diary_entry = DiaryEntry.new

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
