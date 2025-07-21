class Api::V1::BaseController < ApplicationController
  before_action :authenticate_user!
  
  respond_to :json
  
  private
  
  def render_error(message, status = :unprocessable_entity)
    render json: { error: message }, status: status
  end
end 