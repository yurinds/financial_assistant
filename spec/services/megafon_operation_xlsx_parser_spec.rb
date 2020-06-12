# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MegafonOperationXlsxParser do
  let(:user) { create :user }
  let(:path) { './spec/fixtures/megafon_sample.xlsx' }

  context 'когда парсится файл выписки от мегафона' do
    subject { described_class.new(path: path, user: user).parse }

    it 'вернет количество строк файла' do
      expect(subject.count).to eq 6
    end

    context 'когда есть способ оплаты' do
      let!(:payment_method) { create :payment_method, user: user, name: '5555' }

      it 'вернет массив способов оплаты' do
        expect(subject.pluck(:payment_method).map(&:name)).to eq %w[5555 5555 5555 5555 5555 5555]
      end
    end
  end
end
