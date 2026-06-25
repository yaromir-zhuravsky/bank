# frozen_string_literal: true

class AuthenticationController < ApplicationController
  include Authenticatable

  before_action :authenticate_request, only: %i[logout me]

  def login
    validate_params!(SessionsSchema::Login) => { authentication: { email:, password: } }
    AuthenticationService.login(email:, password:) => { access_token:, refresh_token: }

    render status: :ok, json: { access_token:, refresh_token: }
  rescue AuthenticationService::AuthenticationError
    head :unauthorized
  end

  def logout
    validate_params!(SessionsSchema::Logout) => { authentication: { refresh_token: } }
    AuthenticationService.logout(refresh_token:)

    head :ok
  rescue AuthenticationService::AuthenticationError
    head :unauthorized
  end

  def refresh
    validate_params!(SessionsSchema::Refresh) => { authentication: { refresh_token: } }
    AuthenticationService.refresh(refresh_token:) => { access_token:, refresh_token: }

    render status: :ok, json: { access_token:, refresh_token: }
  rescue AuthenticationService::AuthenticationError
    head :unauthorized
  end

  def me
    render status: :ok, json: {
      user: {
        uuid: current_user.uuid,
        email: current_user.email
      }
    }
  end
end
