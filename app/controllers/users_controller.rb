class UsersController < ApplicationController
  add_flash_types :error
  def index
    @user = User.new
    render "users_settings"
  end
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      render "users_settings"
    else
      flash[:error] = @user.errors.full_messages
      render "users_settings"
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      render "users_settings"
    else
      flash[:error] = @user.errors.full_messages
      render "users_settings"
    end
  end

  def edit
    @user = User.find(params[:id])
    render "_edit_user"
  end

  def destroy
    @logins = params[:id].split(',')
    for login in @logins do
      @user = User.find_by(login: login)
      @user.destroy
    end
    redirect_to action: "index", allow_other_host: true
    #render "users_settings"
  end

  def show
    @logins = params[:id]
    #render "show"
  end

  private
  def user_params
    params.require(:user).permit(:login, :first_name, :last_name, :password, :password_confirmation)
  end
end
