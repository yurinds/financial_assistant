# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OperationsCreator do
  let(:user) { create :user }
  let(:path) { './spec/fixtures/megafon_sample.xlsx' }
  let(:budget) do
    create :budget, user: user,
                    date_from: Date.parse('2020.05.01'),
                    date_to: Date.parse('2020.05.31')
  end

  let(:operations) do
    MegafonOperationXlsxParser.new(path: path, user: user).parse
  end

  context 'когда создаются операции по выписке мегафона' do
    subject do
      described_class.new(operations: operations, budget: budget).perform
    end

    it 'вернет количество созданных операций' do
      expect(subject.count).to eq 6
    end
  end
end
