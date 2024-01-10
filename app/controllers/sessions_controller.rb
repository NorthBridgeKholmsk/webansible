class SessionsController < ApplicationController
  def index
    if session[:user_id]
      redirect_to "/home", :format => 'html'
    else
      render "index", layout: false
    end
  end
  def login_attempt
    authorized_user = User.authenticate(params[:login],params[:password])
    if authorized_user
      session[:user_id] = authorized_user.id
      redirect_to "/home", :format => 'html'
    else
      flash[:notice] = "Неверный логин и/или пароль"
      redirect_to("/")
    end
  end
end
