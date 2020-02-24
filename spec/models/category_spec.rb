# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    subject { create(:category_income) }

    it { should belong_to(:user).class_name('User') }
    it { should have_many(:operations).class_name('Operation') }
  end

  describe 'validations' do
    subject { create(:category_income) }

    it { should define_enum_for(:operation_type) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id).case_insensitive }
    it { should validate_length_of(:name).is_at_most(20) }
  end

  describe '.check_for_dependent_operations' do
    let(:user) { create(:user) }
    let(:category) { create(:category_income, user: user) }
    let(:budget) { create(:budget, user: user) }
    let(:operation) { create(:operation, budget: budget, category: category) }

    context 'when no more operations with category' do
      it { expect(category.check_for_dependent_operations).to be_truthy }
    end
    context 'when user has one operation with category' do
      it 'returns array with errors' do
        operation.category.destroy

        expect(operation.category.errors[:base]).not_to be_empty
      end
    end
  end
end
