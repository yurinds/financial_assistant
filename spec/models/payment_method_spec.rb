# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  describe 'associations' do
    subject { create(:payment_method) }

    it { should belong_to(:user).class_name('User') }
    it { should have_many(:operations).class_name('Operation') }
  end

  describe 'validations' do
    subject { create(:payment_method) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id).case_insensitive }
    it { should validate_length_of(:name).is_at_most(20) }
  end

  describe '.check_for_dependent_operations' do
    let(:user) { create(:user) }
    let(:payment_method) { create(:payment_method, user: user) }
    let(:budget) { create(:budget, user: user) }
    let(:operation) { create(:operation_with_income, budget: budget, payment_method: payment_method) }

    context 'when no more operations with payment_method' do
      it { expect(payment_method.check_for_dependent_operations).to be_truthy }
    end
    context 'when user has one operation with payment_method' do
      it 'returns array with errors' do
        operation.payment_method.destroy

        expect(operation.payment_method.errors[:base]).not_to be_empty
      end
    end
  end
end
