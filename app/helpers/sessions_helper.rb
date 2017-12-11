module SessionsHelper
  def login
    session[:is_login] = true
  end
end
