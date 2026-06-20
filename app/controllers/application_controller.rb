# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_request

  class ParamsInvalid < StandardError

    attr_reader :errors

    def initialize(errors)
      @errors = errors
      super()
    end
  end

  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ParamsInvalid, with: :params_invalid
  rescue_from OperationsService::DifferentCurrencies, with: :different_currencies

  private

  def authenticate_request
    access_token = request.headers["Authorization"]&.split(" ")&.[](1)
    if access_token.nil?
      render :unathorized unless access_token
      return
    end

    TokensService.decode!(access_token)
  end

  def current_user
    User.find_by(id: TokensService::Decode.perform(request.headers["Authorization"].split(" ")[1])["user_id"])
  end

  def record_invalid(error)
    render json: { errors: error.record.errors }, status: :unprocessable_content
  end

  def record_not_found(error)
    render json: { errors: "#{error.model.downcase} not found" }, status: :not_found
  end

  def params_invalid(error)
    render json: { errors: error.errors }, status: :unprocessable_content
  end

  def different_currencies(error)
    render json: { errors: error.errors }, status: :unprocessable_content
  end

  def validate_params!(schema)
    result = schema.call(params.permit!.to_h)

    raise ParamsInvalid, result.errors.to_h unless result.success?

    result.to_h
  end
end
