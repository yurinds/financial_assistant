# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    context 'when anon get stats' do
      it 'returns http redirect' do
        get :index
        expect(response).to have_http_status(:redirect)
      end
      it 'redirect to sign in' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when authenticated user' do
      let!(:budget) { create(:budget, user: user) }
      let!(:another_user_budget) { create(:budget, user: another_user) }

      before(:each) do
        sign_in user
      end

      context 'when user views his stats' do
        it 'returns http status redirect' do
          get :index
          expect(response).to have_http_status(:redirect)
        end

        it 'redirect to show budget stats' do
          get :index
          expect(response).to redirect_to(stat_path(budget.id))
        end

        it 'shows only user budget stats' do
          get :index
          stats_facade = assigns(:stats_facade)

          expect(stats_facade.budgets).to eq user.budgets
        end
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    context 'when anon get stats' do
      let(:budget) { create(:budget, user: user) }

      it 'returns http redirect' do
        get :show, params: { id: budget.id }
        expect(response).to have_http_status(:redirect)
      end
      it 'redirect to sign in' do
        get :show, params: { id: budget.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when authenticated user' do
      let!(:budget) { create(:budget, user: user) }
      let!(:another_user_budget) { create(:budget, user: another_user) }

      before(:each) do
        sign_in user
      end

      context 'when show users budget stat' do
        it 'returns http success' do
          get :show, params: { id: budget.id }

          expect(response).to have_http_status(:success)
        end

        it 'current_budget var == budget' do
          get :show, params: { id: budget.id }
          stats_facade = assigns(:stats_facade)

          expect(stats_facade.current_budget).to eq budget
        end
      end

      context 'when user views another user stats' do
        it 'has flash error message' do
          get :show, params: { id: another_user_budget.id }

          expect(flash[:error]).to be
        end
        it 'rescue from Pundit authorize error' do
          get :show, params: { id: another_user_budget.id }

          should rescue_from(Pundit::NotAuthorizedError).with(:user_not_authorized)
        end
      end
    end
  end
end
