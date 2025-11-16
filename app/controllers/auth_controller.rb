class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /login
  # body: { "email": "...", "password": "..." }
  def login
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      # rotate token on every login (safer)
      user.reset_auth_token!

      render json: {
        success: true,
        message: "Login successful",
        token: user.auth_token,
        user: serialize_user(user)
      }, status: :ok
    else
      render json: { success: false, error: "Invalid email or password" },
             status: :unauthorized
    end
  end

  # GET /me
  # Header: Authorization: Bearer TOKEN
  def me
    user = authenticate_with_token

    if user
      render json: serialize_user(user)
    else
      render json: { error: "Not authenticated" }, status: :unauthorized
    end
  end

  # DELETE /logout
  # Header: Authorization: Bearer TOKEN
  def logout
    user = authenticate_with_token

    if user
      user.reset_auth_token!
      render json: { success: true, message: "Logged out" }
    else
      render json: { error: "Not authenticated" }, status: :unauthorized
    end
  end

  private

  def authenticate_with_token
    auth_header = request.headers["Authorization"].to_s
    token = auth_header.split(" ").last
    return nil if token.blank?

    User.find_by(auth_token: token)
  end

  def serialize_user(user)
    {
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      phone: user.phone,
      role: user.role
    }
  end
end
