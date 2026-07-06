# frozen_string_literal: true

class TestController < ApplicationController
  def index
    render json: { message: "Hello World" }
  end
end
