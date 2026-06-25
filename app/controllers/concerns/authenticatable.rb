# frozen_string_literal: true

module Authenticatable
  extend ActiveSupport::Concern

  def current_user
    @current_session.user
  end

  def authenticate_request
    TokensService.decode(access_token) => { sid: }
    @current_session = Session.find_by!(uuid: sid)

    head :unauthorized unless @current_session.active?
  rescue TokensService::DecodeError, ActiveRecord::RecordNotFound
    head :unauthorized
  end

  private

  def access_token
    _authentication_scheme, access_token = request.headers["Authorization"].to_s.split
    access_token
  end
end
