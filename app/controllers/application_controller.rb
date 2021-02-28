class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    command = AuthorizeApiRequest.call(request.headers)

    render json: { message: command.errors[:token].first }, status: :unauthorized and return if command.failure?

    @current_user = command.result
  end
end
