class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :get_prefectures
  before_action :get_tags
  protect_from_forgery with: :exception

  # ログイン後の遷移先
  def after_sign_in_path_for(resource)
    posts_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def get_prefectures
    @prefectures = Prefecture.all
  end

  def get_tags
    @tags = Tag.all
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:email, :name, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end
end
