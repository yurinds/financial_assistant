# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    subject { create(:user) }

    it { should have_many(:budgets).class_name('Budget') }
    it { should have_many(:categories).class_name('Category') }
    it { should have_many(:payment_methods).class_name('PaymentMethod') }
  end

  describe 'validations' do
    subject { create(:user) }

    it { should validate_presence_of(:username) }
    it { should validate_length_of(:username).is_at_most(35) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  end
end
