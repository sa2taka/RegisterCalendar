module SessionsHelper
  def login
    session[:is_login] = true
  end

  def logout
    session[:is_login] = false
  end
end
