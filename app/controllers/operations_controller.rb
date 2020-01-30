# frozen_string_literal: true

class OperationsController < ApplicationController
  def index
    @operation = Operation.all
  end

  def show
    @operation = Operation.all
  end
end
