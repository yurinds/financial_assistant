# frozen_string_literal: true

class OperationsController < ApplicationController
  before_action :find_operation, only: %i[edit update destroy]
  before_action :find_budget
  before_action :set_dependencies, only: %i[create update new edit]

  def new
    @operation = @budget.operations.build

    respond_to do |format|
      format.js { render :new }
    end
  end

  def edit
    respond_to do |format|
      format.js { render :new }
    end
  end

  def create
    @operation = @budget.operations.build(allowed_params)

    if @operation.save
      redirect_to @budget, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  def update
    if @operation.update_attributes(allowed_params)
      redirect_to @budget, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  def destroy
    if @operation.destroy
      redirect_to @budget, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  private

  def render_error_messages_by_js
    respond_to do |format|
      format.js { render partial: 'operations/flash', object: @operation, as: 'resource' }
    end
  end

  def set_dependencies
    @budgets = Budget.all_by_user(current_user)
    @operations = Operation.all_by_budget(@budget)
    @categories = Category.by_user(current_user)
  end

  def find_operation
    @operation = Operation.find(params[:id])
  end

  def find_budget
    @budget = Budget.find(params[:budget_id])
  end

  def allowed_params
    params.require(:operation).permit(:date,
                                      :operation_type,
                                      :description,
                                      :category_id,
                                      :amount)
  end
end
