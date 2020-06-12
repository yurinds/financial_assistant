# frozen_string_literal: true

class MegafonOperationXlsxParser
  attr_reader :file_path, :budget, :user

  def initialize(path:, user:)
    @file_path = path
    @user = user
  end

  def parse
    xlsx = Roo::Excelx.new(file_path)

    operations = xlsx.sheet(0).each(xls_settings).with_object([]) do |row, obj|
      payment_method = PaymentMethod.find_by(name: row[:payment_method], user: user)

      obj << row.merge(payment_method: payment_method)
      obj
    end

    operations.shift
    operations
  end

  private

  def xls_settings
    @_settings ||= Settings.xlsx.megafon.to_h
  end
end
