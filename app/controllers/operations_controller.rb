# frozen_string_literal: true

class OperationsController < ApplicationController
  before_action :find_operation, only: %i[update destroy]
  before_action :find_budget, only: %i[create]

  def create
    @operation = @budget.operations.build(allowed_params)

    if @operation.save
      flash[:success] = t('.success')
    else
      flash[:error] = t('.error')
    end

    redirect_to budgets_path # ! Заглушка.В дальнейшем, всё должно отрабатываться на одной странице
  end

  def update
    if @operation.update_attributes(allowed_params)
      flash[:success] = t('.success')
    else
      flash[:error] = t('.error')
    end

    redirect_to budgets_path # ! Заглушка.В дальнейшем, всё должно отрабатываться на одной странице
  end

  def destroy
    if @operation.destroy
      flash[:success] = t('.success')
    else
      flash[:error] = t('.error')
    end

    redirect_to budgets_path # ! Заглушка.В дальнейшем, всё должно отрабатываться на одной странице
  end

  private

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
