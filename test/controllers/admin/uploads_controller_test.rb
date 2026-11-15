require "test_helper"

class Admin::UploadsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as users(:one) }

  test "uploads an image and shows paste-ready markdown" do
    assert_difference("Upload.count") do
      post admin_uploads_path, params: { upload: { title: "Deploy diagram", file: fixture_file_upload("cover.png", "image/png") } }
    end
    assert_redirected_to admin_uploads_path
    follow_redirect!
    assert_select "input.copy-field[value*='![Deploy diagram](/rails/active_storage/blobs/']"
  end

  test "rejects non-images" do
    assert_no_difference("Upload.count") do
      post admin_uploads_path, params: { upload: { file: fixture_file_upload("notes.txt", "text/plain") } }
    end
    assert_response :unprocessable_entity
    assert_select ".flash--alert", /must be a PNG, JPEG/
  end

  test "deletes an image" do
    upload = Upload.create!(file: fixture_file_upload("cover.png", "image/png"))
    assert_difference("Upload.count", -1) { delete admin_upload_path(upload) }
  end
end
