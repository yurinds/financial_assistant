# frozen_string_literal: true

class PaymentMethodsController < ApplicationController
  before_action :find_payment_method, except: %i[index new create]
  before_action :find_payment_methods_by_user, only: %i[index create]
  before_action :build_payment_method, only: %i[index new]

  def index; end

  def new
    respond_to do |format|
      format.js { render :form }
    end
  end

  def edit
    respond_to do |format|
      format.js { render :form }
    end
  end

  def create
    @payment_method = current_user.payment_methods.build(allowed_params)

    if @payment_method.save
      redirect_to payment_methods_path, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  def update
    if @payment_method.update_attributes(allowed_params)
      redirect_to payment_methods_path, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  def destroy
    if @payment_method.destroy
      redirect_to payment_methods_path, notice: t('.success')
    else
      render_error_messages_by_js
    end
  end

  private

  def render_error_messages_by_js
    respond_to do |format|
      format.js { render partial: 'partials/flash', object: @payment_method, as: 'resource' }
    end
  end

  def find_payment_methods_by_user
    @payment_methods = PaymentMethod.by_user(current_user)
  end

  def allowed_params
    params.require(:payment_method).permit(:name, :is_cash)
  end

  def find_payment_method
    @payment_method = PaymentMethod.find(params[:id])
  end

  def build_payment_method
    @payment_method = current_user.payment_methods.build
  end
end
