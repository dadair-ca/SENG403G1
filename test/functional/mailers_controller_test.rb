require 'test_helper'

class MailersControllerTest < ActionController::TestCase
  setup do
    @mailer = mailers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mailers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mailer" do
    assert_difference('Mailer.count') do
      post :create, :mailer => { :body => @mailer.body, :id => @mailer.id, :subject => @mailer.subject }
    end

    assert_redirected_to mailer_path(assigns(:mailer))
  end

  test "should show mailer" do
    get :show, :id => @mailer
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @mailer
    assert_response :success
  end

  test "should update mailer" do
    put :update, :id => @mailer, :mailer => { :body => @mailer.body, :id => @mailer.id, :subject => @mailer.subject }
    assert_redirected_to mailer_path(assigns(:mailer))
  end

  test "should destroy mailer" do
    assert_difference('Mailer.count', -1) do
      delete :destroy, :id => @mailer
    end

    assert_redirected_to mailers_path
  end
end
