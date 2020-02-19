# frozen_string_literal: true

module CategoriesHelper
  def operation_types
    Category.operation_types.map { |key, _value| [t(".type_#{key}"), key] }
  end
end
