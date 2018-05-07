class UsersController < ApplicationController

  def show
    find_user_by_id
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      session[:user_id] = @user.id
      redirect_to @user
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to register_path
    end
  end

  def edit
    find_user_by_id
    @encounters = Encounter.where(user_id: nil).or(Encounter.where(user_id: @user.id))
  end

  def update
    find_user_by_id
    authorized_for_user(@user)
    @user.update(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, encounter_ids: [], character_ids: [])
  end

  def find_user_by_id
    @user = User.find(params[:id])
  end
end
