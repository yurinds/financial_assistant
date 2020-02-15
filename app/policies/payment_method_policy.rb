# frozen_string_literal: true

class PaymentMethodPolicy < ApplicationPolicy
  attr_reader :user, :payment_method

  def initialize(user, payment_method)
    @user = user
    @payment_method = payment_method
  end

  def edit?
    user.payment_methods.find_by(id: payment_method.id)
  end

  alias update? edit?
  alias destroy? edit?
end
