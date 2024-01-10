class HomeController < ApplicationController
  before_action :authenticate_user
  def index
    # code here
  end

  def logout
    session[:user_id] = nil
    redirect_to "/"
  end
end
