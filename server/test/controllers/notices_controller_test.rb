require 'test_helper'

class NoticesControllerTest < ActionController::TestCase
  setup do
    @notice = notices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create notice" do
    assert_difference('Notice.count') do
      post :create, notice: { after_data: @notice.after_data, before_data: @notice.before_data, campus_id: @notice.campus_id, category_id: @notice.category_id, date: @notice.date, department_id: @notice.department_id, details: @notice.details, document1_name: @notice.document1_name, document1_url: @notice.document1_url, document2_name: @notice.document2_name, document2_url: @notice.document2_url, document3_name: @notice.document3_name, document3_url: @notice.document3_url, document4_name: @notice.document4_name, document4_url: @notice.document4_url, document5_name: @notice.document5_name, document5_url: @notice.document5_url, grade: @notice.grade, note: @notice.note, period_time: @notice.period_time, place: @notice.place, regist_time: @notice.regist_time, subject: @notice.subject, teacher: @notice.teacher, title: @notice.title, web_url: @notice.web_url }
    end

    assert_redirected_to notice_path(assigns(:notice))
  end

  test "should show notice" do
    get :show, id: @notice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @notice
    assert_response :success
  end

  test "should update notice" do
    patch :update, id: @notice, notice: { after_data: @notice.after_data, before_data: @notice.before_data, campus_id: @notice.campus_id, category_id: @notice.category_id, date: @notice.date, department_id: @notice.department_id, details: @notice.details, document1_name: @notice.document1_name, document1_url: @notice.document1_url, document2_name: @notice.document2_name, document2_url: @notice.document2_url, document3_name: @notice.document3_name, document3_url: @notice.document3_url, document4_name: @notice.document4_name, document4_url: @notice.document4_url, document5_name: @notice.document5_name, document5_url: @notice.document5_url, grade: @notice.grade, note: @notice.note, period_time: @notice.period_time, place: @notice.place, regist_time: @notice.regist_time, subject: @notice.subject, teacher: @notice.teacher, title: @notice.title, web_url: @notice.web_url }
    assert_redirected_to notice_path(assigns(:notice))
  end

  test "should destroy notice" do
    assert_difference('Notice.count', -1) do
      delete :destroy, id: @notice
    end

    assert_redirected_to notices_path
  end
end
