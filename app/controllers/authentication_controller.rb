# frozen_string_literal: true

class AuthenticationController < ApplicationController
  def login
    user_info = validate_params!(AuthenticationSchema::Create)[:user]

    user = User.find_by!(email: user_info[:email])
    if user.authenticate(user_info[:password])
      token_payload = { user_id: user.id }
      access_token = TokensService::Encode.perform(token_payload, 15.minutes.from_now.to_i)
      refresh_token = TokensService::Encode.perform(token_payload, 30.days.from_now.to_i)

      cookies[:refresh_token] = {
        value: refresh_token,
        httponly: true,
        secure: false,
        same_site: :lax,
        expires: 30.days.from_now
      }

      render status: :ok, json: { access_token: }
    else
      render status: :unauthorized, json: { error: "invalid email or password" }
    end
  end

  def logout
    refresh_token = cookies[:refresh_token]
    payload = TokensService::Decode.perform(refresh_token)
    RevokedToken.create!(jti: payload["jti"], exp: Time.at(payload["exp"]))
    cookies.delete(:refresh_token)
  end

  def refresh
    refresh_token = cookies[:refresh_token]
    payload = TokensService::Decode.perform(refresh_token)
    token_payload = { user_id: payload["user_id"] }
    if RevokedToken.exists?(jti: payload["jti"])
      render status: :unauthorized
    else
      access_token = TokensService::Encode.perform(token_payload, 15.minutes.from_now.to_i)
      refresh_token = TokensService::Encode.perform(token_payload, 30.days.from_now.to_i)
      RevokedToken.create!(jti: payload["jti"], exp: Time.at(payload["exp"]))
      cookies[:refresh_token] = {
        value: refresh_token,
        httponly: true,
        secure: false,
        same_site: :lax,
        expires: 30.days.from_now
      }
      render status: :ok, json: { access_token: }
    end
  end
end
