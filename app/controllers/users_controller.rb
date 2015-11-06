class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
#    debugger
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success]= "Your account have been create, welcome there bro!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
end
