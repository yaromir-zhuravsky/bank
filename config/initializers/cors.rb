# frozen_string_literal: true

allowed_origins =
  if Rails.env.production?
    %w[https://app.example.com]
  else
    %w[http://localhost:3000 http://127.0.0.1:3000]
  end

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*allowed_origins)

    resource "*",
             headers: :any,
             methods: %i[get post options],
             credentials: true
  end
end
