# frozen_string_literal: true

class AuthenticationService
  ACCESS_TOKEN_TTL = 1.minute
  REFRESH_TOKEN_TTL = 1.hour

  class AuthenticationError < StandardError; end
  class RefreshTokenError < AuthenticationError; end
  class InvalidCredentialsError < AuthenticationError; end

  def self.login(email:, password:)
    user = User.find_by(email:)
    raise InvalidCredentialsError if user.nil?
    raise InvalidCredentialsError unless user.authenticate(password)

    session = Session.create!(
      user:,
      expires_at: REFRESH_TOKEN_TTL.from_now,
      current_refresh_jti: SecureRandom.uuid
    )
    generate_tokens(session)
  end

  def self.logout(refresh_token:)
    TokensService.decode(refresh_token) => { sid:, jti: }
    Session.transaction do
      session = Session.lock.find_by!(uuid: sid)
      raise RefreshTokenError unless session.active?
      raise RefreshTokenError unless session.current_refresh_jti == jti

      session.update!(revoked_at: Time.zone.now)
    end
  rescue TokensService::DecodeError, ActiveRecord::RecordNotFound
    raise RefreshTokenError
  end

  def self.refresh(refresh_token:)
    TokensService.decode(refresh_token) => { sid:, jti: }
    Session.transaction do
      session = Session.lock.find_by!(uuid: sid)
      raise RefreshTokenError unless session.active?
      raise RefreshTokenError unless session.current_refresh_jti == jti

      session.update!(
        expires_at: REFRESH_TOKEN_TTL.from_now,
        current_refresh_jti: SecureRandom.uuid
      )
      generate_tokens(session)
    end
  rescue TokensService::DecodeError, ActiveRecord::RecordNotFound
    raise RefreshTokenError
  end

  def self.generate_tokens(session)
    {
      access_token: TokensService.encode(
        jti: SecureRandom.uuid,
        exp: ACCESS_TOKEN_TTL.from_now.to_i,
        sub: session.user.uuid,
        sid: session.uuid
      ),
      refresh_token: TokensService.encode(
        jti: session.current_refresh_jti,
        exp: session.expires_at.to_i,
        sub: session.user.uuid,
        sid: session.uuid
      )
    }
  end
end
