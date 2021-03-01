class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: :create
  before_action :set_user, only: %i[show update destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    render json: { message: 'Usuário não existe' }, status: :not_found and return if @user.blank?
  end

  # POST /users
  def create
    if User.find_by(email: user_params[:email])
      render json: { message: 'Usuário já existe' },
             status: :conflict and return
    end

    @user = User.new(user_params)

    if @user.save
      command = AuthenticateUser.call(user_params[:email], user_params[:password])

      render json: { token: command.result }, status: :created, location: @user
    else
      attribute, errors = @user.errors.messages.first
      render json: { message: "\"#{attribute}\" #{errors.first}" }, status: :bad_request
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render 'show.json'
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/me
  def me
    @current_user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    @user_params ||= params.permit(:displayName, :email, :image, :password)
  end
end
