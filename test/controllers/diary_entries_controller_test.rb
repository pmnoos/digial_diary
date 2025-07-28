require "test_helper"

class DiaryEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @diary_entry = diary_entries(:one)
  end

  test "should get index" do
    get diary_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_diary_entry_url
    assert_response :success
  end

  test "should create diary_entry" do
    assert_difference("DiaryEntry.count") do
      post diary_entries_url, params: { diary_entry: { entry_date: @diary_entry.entry_date, status: @diary_entry.status, title: @diary_entry.title } }
    end

    assert_redirected_to diary_entry_url(DiaryEntry.last)
  end

  test "should show diary_entry" do
    get diary_entry_url(@diary_entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_diary_entry_url(@diary_entry)
    assert_response :success
  end

  test "should update diary_entry" do
    patch diary_entry_url(@diary_entry), params: { diary_entry: { entry_date: @diary_entry.entry_date, status: @diary_entry.status, title: @diary_entry.title } }
    assert_redirected_to diary_entry_url(@diary_entry)
  end

  test "should destroy diary_entry" do
    assert_difference("DiaryEntry.count", -1) do
      delete diary_entry_url(@diary_entry)
    end

    assert_redirected_to diary_entries_url
  end
end
