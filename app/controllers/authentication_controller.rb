# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [:login, :refresh]

  def login
    validated_params = validate_params!(AuthenticationSchema::Logout)
    authentication_info = validated_params[:authentication]
    user = User.find_by!(email: authentication_info[:email])
    if user.authenticate(authentication_info[:password])
      payload = { user_id: user.id }
      access_token = TokensService.access_token(payload)
      refresh_token = TokensService.refresh_token(payload)

      render status: :ok, json: { access_token:, refresh_token: }
    end
  end

  def logout
    validated_params = validate_params!(AuthenticationSchema::Logout)
    authentication_info = validated_params[:authentication]
    refresh_token = authentication_info[:refresh_token]
    if TokensService.revoked?(refresh_token)
      render status: :unauthorized
    else
      TokensService.revoke!(refresh_token)
    end

    head :ok
  end

  def refresh
    validated_params = validate_params!(AuthenticationSchema::Logout)
    authentication_info = validated_params[:authentication]
    refresh_token = authentication_info[:refresh_token]
    if TokensService.revoked?(refresh_token)
      render status: :unauthorized
    else
      payload = TokensService.decode!(refresh_token)
      TokensService.revoke!(authentication_info[:refresh_token])
      access_token = TokensService.access_token(payload)
      refresh_token = TokensService.access_token(payload)

      render status: :ok, json: { access_token:, refresh_token: }
    end
  end
end
