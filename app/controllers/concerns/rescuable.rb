# frozen_string_literal: true

module Rescuable
  extend ActiveSupport::Concern

  class ParamsInvalid < StandardError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
      super()
    end
  end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ParamsInvalid, with: :params_invalid
    rescue_from OperationsService::DifferentCurrencies, with: :different_currencies
    rescue_from JWT::DecodeError, with: :decode_error
  end

  private

  def decode_error(error)
    render json: { errors: error.message }, status: :bad_request
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
end
