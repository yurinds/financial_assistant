# frozen_string_literal: true

class BudgetsController < ApplicationController
  def index
    @budget = Budget.all
  end

  def show
    @budget = Budget.all
  end
end
