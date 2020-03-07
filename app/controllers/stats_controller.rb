# frozen_string_literal: true

class StatsController < ApplicationController
  def index
    current_budget = stats_facade.first_user_budget

    if current_budget.nil?
      redirect_to new_budget_path
    else
      authorize current_budget

      redirect_to stat_path current_budget.id
    end
  end

  def show
    current_budget = stats_facade.current_budget

    redirect_to budgets_path if current_budget.nil?

    authorize current_budget
  end

  private

  def stats_facade
    @stats_facade ||= StatsFacade.new(current_user, params)
  end
end
