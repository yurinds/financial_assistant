# frozen_string_literal: true

class PaymentMethodFacade
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def payment_methods
    @payment_methods ||= PaymentMethod.by_user(user)
  end

  def payment_method
    params[:id] ? set_payment_method : new_payment_method
  end

  def new_payment_method(allowed_params = {})
    @new_payment_method ||= user.payment_methods.build(allowed_params)
  end

  private

  def set_payment_method
    @payment_method ||= PaymentMethod.find(params[:id])
  end
end
