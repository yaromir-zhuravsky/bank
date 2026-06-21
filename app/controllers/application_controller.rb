# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Rescuable

  before_action :authenticate_request

  class ParamsInvalid < StandardError

    attr_reader :errors

    def initialize(errors)
      @errors = errors
      super()
    end
  end


  private

  def authenticate_request
    access_token = request.headers["Authorization"]&.split(" ")&.[](1)
    if access_token.nil?
      render status: :unauthorized unless access_token
      return
    end

    TokensService.decode!(access_token)
  end

  def current_user
    User.find_by(id: TokensService.decode(request.headers["Authorization"].split(" ")[1])["user_id"])
  end

  def validate_params!(schema)
    result = schema.call(params.permit!.to_h)

    raise ParamsInvalid, result.errors.to_h unless result.success?

    result.to_h
  end
end
