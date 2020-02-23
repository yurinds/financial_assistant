# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Budget, type: :model do
  describe 'associations' do
    subject { create(:budget) }

    it { should belong_to(:user).class_name('User') }
    it { should have_many(:operations).class_name('Operation') }
  end

  describe 'validations' do
    subject { create(:budget) }

    it { should validate_presence_of(:date_from) }
    it { should validate_uniqueness_of(:date_from).scoped_to(:user_id) }
    it { should validate_presence_of(:date_to) }
    it { should validate_uniqueness_of(:date_to).scoped_to(:user_id) }
  end

  context 'when budget is deleted' do
    let(:budget_with_operations) { create(:budget_with_operations) }
    let(:budget) { create(:budget) }

    it 'have error' do
      budget_with_operations.destroy

      expect(budget_with_operations.errors[:base]).not_to be_empty
    end
    it 'successfully deleted' do
      budget.destroy

      expect(budget.persisted?).to be_falsey
    end
  end

  context 'when created new budget' do
    let(:budget) { build(:budget, date_from: nil, date_to: nil) }

    it 'set date_from and date_to' do
      current_date = budget.date
      date = Date.parse(current_date)

      expect(budget.date_from).to eq nil
      expect(budget.date_to).to eq nil

      budget.valid?

      expect(budget.date_from).to eq date.beginning_of_month
      expect(budget.date_to).to eq date.end_of_month
    end
  end
end
