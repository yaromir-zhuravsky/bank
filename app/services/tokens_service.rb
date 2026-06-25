# frozen_string_literal: true

class TokensService
  JWT_SECRET = ENV.fetch("JWT_SECRET")
  ALGORITHM = "HS256"

  class DecodeError < StandardError; end
  class EncodeError < StandardError; end

  def self.encode(**payload)
    JWT.encode(
      payload,
      JWT_SECRET,
      ALGORITHM
    )
  rescue JWT::EncodeError
    raise EncodeError
  end

  def self.decode(token)
    payload, _headers = JWT.decode(
      token,
      JWT_SECRET,
      true,
      algorithm: ALGORITHM,
      verify_expiration: true
    )

    payload.deep_symbolize_keys
  rescue JWT::DecodeError
    raise DecodeError
  end
end
