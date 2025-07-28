json.extract! diary_entry, :id, :title, :entry_date, :status, :created_at, :updated_at
json.url diary_entry_url(diary_entry, format: :json)
