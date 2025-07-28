require "application_system_test_case"

class DiaryEntriesTest < ApplicationSystemTestCase
  setup do
    @diary_entry = diary_entries(:one)
  end

  test "visiting the index" do
    visit diary_entries_url
    assert_selector "h1", text: "Diary entries"
  end

  test "should create diary entry" do
    visit diary_entries_url
    click_on "New diary entry"

    fill_in "Entry date", with: @diary_entry.entry_date
    fill_in "Status", with: @diary_entry.status
    fill_in "Title", with: @diary_entry.title
    click_on "Create Diary entry"

    assert_text "Diary entry was successfully created"
    click_on "Back"
  end

  test "should update Diary entry" do
    visit diary_entry_url(@diary_entry)
    click_on "Edit this diary entry", match: :first

    fill_in "Entry date", with: @diary_entry.entry_date
    fill_in "Status", with: @diary_entry.status
    fill_in "Title", with: @diary_entry.title
    click_on "Update Diary entry"

    assert_text "Diary entry was successfully updated"
    click_on "Back"
  end

  test "should destroy Diary entry" do
    visit diary_entry_url(@diary_entry)
    click_on "Destroy this diary entry", match: :first

    assert_text "Diary entry was successfully destroyed"
  end
end
