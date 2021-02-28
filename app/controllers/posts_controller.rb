class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]

  # GET /posts
  def index
    @posts = Post.all
  end

  # GET /posts/1
  def show
    render json: { message: 'Post não existe' }, status: :not_found and return if @post.blank?
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.user = @current_user

    if @post.save
      render status: :created
    else
      attribute, errors = @post.errors.messages.first
      render json: { message: "\"#{attribute}\" #{errors.first}" }, status: :bad_request
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find_by(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    @post_params ||= params.permit(:title, :content)
  end
end
