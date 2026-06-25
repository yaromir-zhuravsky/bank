# frozen_string_literal: true

module SessionsSchema
  Login = Dry::Schema.Params do
    required(:authentication).hash do
      required(:email).filled(:string)
      required(:password).filled(:string)
    end
  end

  Logout = Dry::Schema.Params do
    required(:authentication).hash do
      required(:refresh_token).filled(:string)
    end
  end

  Refresh = Dry::Schema.Params do
    required(:authentication).hash do
      required(:refresh_token).filled(:string)
    end
  end
end
