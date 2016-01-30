require 'test_helper'

class LecturesControllerTest < ActionController::TestCase
  setup do
    @lecture = lectures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lectures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lecture" do
    assert_difference('Lecture.count') do
      post :create, lecture: { campus_id: @lecture.campus_id, class_id: @lecture.class_id, sub_id: @lecture.sub_id, teacher: @lecture.teacher, term: @lecture.term, title: @lecture.title, week_time: @lecture.week_time, year: @lecture.year }
    end

    assert_redirected_to lecture_path(assigns(:lecture))
  end

  test "should show lecture" do
    get :show, id: @lecture
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lecture
    assert_response :success
  end

  test "should update lecture" do
    patch :update, id: @lecture, lecture: { campus_id: @lecture.campus_id, class_id: @lecture.class_id, sub_id: @lecture.sub_id, teacher: @lecture.teacher, term: @lecture.term, title: @lecture.title, week_time: @lecture.week_time, year: @lecture.year }
    assert_redirected_to lecture_path(assigns(:lecture))
  end

  test "should destroy lecture" do
    assert_difference('Lecture.count', -1) do
      delete :destroy, id: @lecture
    end

    assert_redirected_to lectures_path
  end
end
