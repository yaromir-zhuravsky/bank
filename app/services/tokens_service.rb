# frozen_string_literal: true

module TokensService
  JWT_SECRET = Rails.application.credentials.jwt_secret
  JWT_SECRET = ENV.fetch("JWT_SECRET")

  class Encode
    def self.perform(payload, exp)
      JWT.encode({ **payload, exp:, jti: SecureRandom.uuid }, JWT_SECRET, "HS256")
    end
  end

  class Decode
    def self.perform(token)
      JWT.decode(token, JWT_SECRET, "HS256")[0]
    end
  end
end
