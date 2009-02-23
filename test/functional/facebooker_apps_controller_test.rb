require File.dirname(__FILE__) + '/../test_helper'

class FacebookerAppsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:facebooker_apps)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_facebooker_app
    assert_difference('FacebookerApp.count') do
      post :create, :facebooker_app => { }
    end

    assert_redirected_to facebooker_app_path(assigns(:facebooker_app))
  end

  def test_should_show_facebooker_app
    get :show, :id => facebooker_apps(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => facebooker_apps(:one).id
    assert_response :success
  end

  def test_should_update_facebooker_app
    put :update, :id => facebooker_apps(:one).id, :facebooker_app => { }
    assert_redirected_to facebooker_app_path(assigns(:facebooker_app))
  end

  def test_should_destroy_facebooker_app
    assert_difference('FacebookerApp.count', -1) do
      delete :destroy, :id => facebooker_apps(:one).id
    end

    assert_redirected_to facebooker_apps_path
  end
end
