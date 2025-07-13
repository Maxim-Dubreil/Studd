class Api::V1::UsersController < Api::V1::BaseController
  def me
    render json: {
      id: current_user.id,
      name: current_user.name || current_user.email.split('@').first.capitalize,
      email: current_user.email,
      avatar: current_user.respond_to?(:avatar) ? current_user.avatar : nil,
      created_at: current_user.created_at
    }
  end
end 