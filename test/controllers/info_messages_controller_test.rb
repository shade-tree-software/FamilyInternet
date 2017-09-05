require 'test_helper'

class InfoMessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @info_message = info_messages(:one)
  end

  test "should get index" do
    get info_messages_url
    assert_response :success
  end

  test "should get new" do
    get new_info_message_url
    assert_response :success
  end

  test "should create info_message" do
    assert_difference('InfoMessage.count') do
      post info_messages_url, params: { info_message: { text: @info_message.text } }
    end

    assert_redirected_to info_message_url(InfoMessage.last)
  end

  test "should show info_message" do
    get info_message_url(@info_message)
    assert_response :success
  end

  test "should get edit" do
    get edit_info_message_url(@info_message)
    assert_response :success
  end

  test "should update info_message" do
    patch info_message_url(@info_message), params: { info_message: { text: @info_message.text } }
    assert_redirected_to info_message_url(@info_message)
  end

  test "should destroy info_message" do
    assert_difference('InfoMessage.count', -1) do
      delete info_message_url(@info_message)
    end

    assert_redirected_to info_messages_url
  end
end
