# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Rescuable

  private

  def validate_params!(schema)
    result = schema.call(params.permit!.to_h)

    raise ParamsInvalid, result.errors.to_h unless result.success?

    result.to_h
  end
end
