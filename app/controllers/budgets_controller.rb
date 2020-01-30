# frozen_string_literal: true

class BudgetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @budget = Budget.all
  end

  def show
    @budget = Budget.all
  end
end
