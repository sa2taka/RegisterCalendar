class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def escape
    unless session[:is_login]
      flash[:danger] = "権限がありません。ログインしてください。"
      redirect_to root_url
    end
  end
end
