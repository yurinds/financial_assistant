# frozen_string_literal: true

class OperationsController < ApplicationController
  before_action :find_operation, only: %i[edit update destroy]
  before_action :find_budget
  before_action :find_categories, only: %i[create update new edit]
  before_action :find_payment_methods, only: %i[create update new edit]

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
      format.js { render partial: 'partials/flash', object: @operation, as: 'resource' }
    end
  end

  def find_categories
    @categories = Category.by_user(current_user)
  end

  def find_payment_methods
    @payment_methods = PaymentMethod.by_user(current_user)
  end

  def find_operation
    @operation = Operation.find(params[:id])
  end

  def find_budget
    @budget = Budget.find(params[:budget_id])
  end

  def allowed_params
    params.require(:operation).permit(:date,
                                      :description,
                                      :category_id,
                                      :payment_method_id,
                                      :amount)
  end
end
