# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Operation, type: :model do
  describe 'associations' do
    subject { create(:operation_with_income) }

    it { should belong_to(:budget).class_name('Budget') }
    it { should belong_to(:category).class_name('Category') }
    it { should belong_to(:payment_method).class_name('PaymentMethod').optional }
  end

  describe 'validations' do
    subject { create(:operation_with_income) }

    it { should define_enum_for(:operation_type) }
    it { should validate_presence_of(:amount) }

    context 'когда указан пустой mcc' do
      let(:mcc) { '' }
      before do
        subject.mcc = mcc
      end

      it { expect(subject).to be_valid }
    end

    context 'когда указан пустой mcc - nil' do
      let(:mcc) { nil }
      before do
        subject.mcc = mcc
      end

      it { expect(subject).to be_valid }
    end
  end

  describe '#operation_date_should_correspond_to_budget_period' do
    let(:operation) { build(:operation_with_income) }

    context 'when operation date is valid' do
      it { expect(operation.valid?).to be_truthy }
    end
    context 'when operation date is not valid' do
      it 'creates date validation error' do
        operation.date = operation.budget.date_from - 1.day
        operation.valid?

        expect(operation.errors[:date]).not_to be_empty
      end
    end
  end

  describe '#set_operation_type!' do
    context 'when category is empty' do
      let(:operation) { build(:operation) }

      it 'return category validation error' do
        operation.valid?
        expect(operation.errors[:category]).not_to be_empty
      end
    end

    context 'when category is full' do
      let(:operation) { build(:operation_with_income) }

      it 'pass validation' do
        operation.valid?
        expect(operation.errors).to be_empty
      end

      it 'has the same type' do
        operation.operation_type = 'expense'
        operation.valid?
        expect(operation.operation_type).to eq operation.category.operation_type
      end
    end
  end

  describe '#set_category_by_mcc!' do
    context 'когда категория пустая, но мсс указан' do
      let(:operation) { build(:operation, mcc: mcc) }

      context 'когда передан валидный мсс' do
        let(:mcc) { 4814 }

        it { expect(operation).to be_valid }
      end

      context 'когда передан не валидный мсс' do
        let(:mcc) { 1488 }

        it { expect(operation).not_to be_valid }
      end
    end

    context 'когда категория и мсс пусты' do
      let(:operation) { build(:operation, mcc: nil) }

      it { expect(operation).not_to be_valid }
    end
  end

  describe '.grouped_by_payment_method_amount' do
    let(:user) { create(:user) }
    let(:budget) { create(:budget, user: user) }
    let(:first_payment_method) { create(:payment_method, user: user) }
    let(:second_payment_method) { create(:payment_method, user: user) }
    let(:operation_income) { create(:operation_with_income, budget: budget, payment_method: first_payment_method) }
    let(:operation_expense) { create(:operation_with_expense, budget: budget, payment_method: second_payment_method) }
    let(:operation_expense_nil) { create(:operation_with_expense, budget: budget, payment_method: nil) }

    context 'when the budget has no operations' do
      it { expect(Operation.grouped_by_payment_method_amount(budget)).to be_empty }
    end

    context 'when the budget has one income operation' do
      it do
        expected = [[operation_income.payment_method, operation_income.operation_type, operation_income.amount]]
        result = Operation.grouped_by_payment_method_amount(budget)
                          .map { |item| [item.payment_method, item.operation_type, item.amount] }

        expect(result).to eq expected
      end
    end

    context 'when the budget has one expense operation' do
      it do
        expected = [[operation_expense.payment_method, operation_expense.operation_type, operation_expense.amount]]
        result = Operation.grouped_by_payment_method_amount(budget)
                          .map { |item| [item.payment_method, item.operation_type, item.amount] }

        expect(result).to eq expected
      end
    end

    context 'when the budget has income and expense operations' do
      it do
        expected = [
          [operation_expense.payment_method, operation_expense.operation_type, operation_expense.amount],
          [operation_income.payment_method, operation_income.operation_type, operation_income.amount]
        ]
        result = Operation.grouped_by_payment_method_amount(budget)
                          .map { |item| [item.payment_method, item.operation_type, item.amount] }

        expect(result).to eq expected
      end
    end

    context 'when the budget has income and expense and one nil' do
      it do
        expected = [
          [operation_expense.payment_method, operation_expense.operation_type, operation_expense.amount],
          [operation_income.payment_method, operation_income.operation_type, operation_income.amount],
          [operation_expense_nil.payment_method, operation_expense_nil.operation_type, operation_expense_nil.amount]

        ]

        result = Operation.grouped_by_payment_method_amount(budget)
                          .map { |item| [item.payment_method, item.operation_type, item.amount] }

        expect(result).to eq expected
      end
    end
  end
end
