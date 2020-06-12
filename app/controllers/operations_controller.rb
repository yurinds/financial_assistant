# frozen_string_literal: true

class OperationsController < ApplicationController
  def new
    operation = operations_facade.new_operation

    respond_to do |format|
      format.js { render :new }
    end
  end

  def edit
    authorize operations_facade.operation

    respond_to do |format|
      format.js { render :new }
    end
  end

  def create
    operation = operations_facade.new_operation(allowed_params)

    if operation.save
      redirect_to operations_facade.budget, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  def update
    authorize operations_facade.operation

    if operations_facade.operation.update_attributes(allowed_params)
      redirect_to operations_facade.budget, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  def destroy
    authorize operations_facade.operation

    if operations_facade.operation.destroy
      redirect_to operations_facade.budget, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  private

  def render_error_messages_by_js
    respond_to do |format|
      format.js { render partial: 'partials/flash', object: operations_facade.operation, as: 'resource' }
    end
  end

  def operations_facade
    @operations_facade ||= OperationsFacade.new(current_user, params)
  end

  def allowed_params
    params.require(:operation).permit(:date,
                                      :description,
                                      :category_id,
                                      :payment_method_id,
                                      :amount,
                                      :mcc)
  end
end
