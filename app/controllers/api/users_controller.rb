class Api::UsersController < ApplicationController
  def create
    user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      total_games_as_sith: 0,
      total_games_as_senator: 0,
      total_games_as_palpatine: 0,
      wins_as_sith: 0,
      losses_as_sith: 0,
      wins_as_senator: 0,
      losses_as_senator: 0,
      wins_as_palpatine: 0,
      losses_as_palpatine: 0
    )
    if user.save
      render json: { message: "User created successfully" }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def show
    @user = User.find(params[:id])
    render 'show.json.jbuilder'
  end
end
