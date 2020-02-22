# frozen_string_literal: true

class PaymentMethodsController < ApplicationController
  before_action :payment_methods_facade, only: %i[index new]

  def index; end

  def new
    respond_to do |format|
      format.js { render :form }
    end
  end

  def edit
    authorize payment_methods_facade.payment_method

    respond_to do |format|
      format.js { render :form }
    end
  end

  def create
    payment_method = payment_methods_facade.new_payment_method(allowed_params)

    if payment_method.save
      redirect_to payment_methods_path, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  def update
    payment_method = payment_methods_facade.payment_method

    authorize payment_method

    if payment_method.update_attributes(allowed_params)
      redirect_to payment_methods_path, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  def destroy
    authorize payment_methods_facade.payment_method

    if @payment_methods_facade.payment_method.destroy
      redirect_to payment_methods_path, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  private

  def render_error_messages_by_js
    respond_to do |format|
      format.js { render partial: 'partials/flash', object: payment_methods_facade.payment_method, as: 'resource' }
    end
  end

  def payment_methods_facade
    @payment_methods_facade ||= PaymentMethodFacade.new(current_user, params)
  end

  def allowed_params
    params.require(:payment_method).permit(:name, :is_cash)
  end
end
