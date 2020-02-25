# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BudgetsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }

    context 'when an unauthenticated user' do
      before(:each) do
        get :index
      end

      it 'returns redirect status' do
        expect(response).to have_http_status(:redirect)
      end
      it 'redirect to new user session path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context 'when authenticated user' do
      context 'when user has no one budget' do
        before(:each) do
          sign_in user
          get :index
        end

        it 'redirect to new budget' do
          expect(response).to redirect_to(new_budget_path)
        end
        it 'have status redirect' do
          expect(response).to have_http_status(:redirect)
        end
      end

      context 'when the user has a budget' do
        let!(:budget) { create(:budget, user: user) }
        before(:each) do
          sign_in user
          get :index
        end

        it 'redirect to budget' do
          expect(response).to redirect_to(budget_path(budget))
        end
        it 'have status redirect' do
          expect(response).to have_http_status(:redirect)
        end
      end
    end
  end

  describe 'GET #new' do
    let(:user) { create(:user) }

    context 'when an unauthenticated user' do
      before(:each) do
        get :new
      end

      it 'returns redirect status' do
        expect(response).to have_http_status(:redirect)
      end
      it 'redirect to new user session path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when authenticated user' do
      before(:each) do
        sign_in user
        get :new
      end

      it { should render_template('new') }
      it 'returns http status success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'when an unauthenticated user' do
      before(:each) do
        post :create, params: { budget: { date: Date.current } }
      end

      it 'returns redirect status' do
        expect(response).to have_http_status(:redirect)
      end
      it 'redirect to new user session path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when authenticated user' do
      before(:each) do
        sign_in user
      end

      context 'when send valid params' do
        before(:each) do
          post :create, params: { budget: { date: Date.current } }
        end
        let!(:budgets_facade) { assigns(:budgets_facade) }

        it 'confirms that the budget is in the database' do
          expect(budgets_facade.new_budget.persisted?).to be_truthy
        end

        it 'have notice flash message' do
          expect(flash[:notice]).to be_truthy
        end

        it 'creates new budget and redirect to budget' do
          expect(response).to redirect_to(budget_path(budgets_facade.new_budget))
        end
      end

      context 'when send not valid params' do
        before(:each) do
          post :create, params: { budget: { date: '' } }, xhr: true
        end
        let!(:budgets_facade) { assigns(:budgets_facade) }

        it 'confirms that the budget is not created' do
          expect(budgets_facade.new_budget.persisted?).to be_falsey
        end

        it 'have error messages in object' do
          expect(budgets_facade.new_budget.errors).not_to be_empty
        end

        it 'render error messages by js' do
          should render_template(partial: 'partials/_flash')
        end
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:budget) { create(:budget, user: user) }

    context 'when an unauthenticated user' do
      before(:each) do
        get :show, params: { id: budget.id }
      end

      it 'returns redirect status' do
        expect(response).to have_http_status(:redirect)
      end
      it 'redirect to new user session path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when authenticated user' do
      before(:each) do
        sign_in user
      end

      context 'when show budget that belongs to user' do
        before(:each) do
          get :show, params: { id: budget.id }, xhr: true
        end
        let(:budgets_facade) { assigns(:budgets_facade) }

        it 'have http status :success' do
          expect(response).to  have_http_status(:success)
        end

        it 'show current budget' do
          expect(budgets_facade.budget).to eq budget
        end

        it 'render show template' do
          should render_template(:show)
        end
      end

      context 'when show budget that belongs to another user' do
        let(:another_user) { create(:user) }
        let(:another_budget) { create(:budget, user: another_user) }
        before(:each) do
          get :show, params: { id: another_budget.id }, xhr: true
        end

        it 'has flash error message' do
          expect(flash[:error]).to be
        end

        it 'rescue from Pundit authorize error' do
          should rescue_from(Pundit::NotAuthorizedError).with(:user_not_authorized)
        end
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }
    let(:budget) { create(:budget, user: user) }

    context 'when an unauthenticated user' do
      before(:each) do
        get :edit, params: { id: budget.id }
      end

      it 'returns redirect status' do
        expect(response).to have_http_status(:redirect)
      end
      it 'redirect to new user session path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when authenticated user' do
      before(:each) do
        sign_in user
      end

      context 'when edit budget that belongs to user' do
        before(:each) do
          get :edit, params: { id: budget.id }, xhr: true
        end
        let(:budgets_facade) { assigns(:budgets_facade) }

        it 'have http status :success' do
          expect(response).to  have_http_status(:success)
        end

        it 'edit current budget' do
          expect(budgets_facade.budget).to eq budget
        end

        it 'render edit template' do
          should render_template(:edit)
        end
      end

      context 'when edit budget that belongs to another user' do
        let(:another_user) { create(:user) }
        let(:another_budget) { create(:budget, user: another_user) }
        before(:each) do
          get :edit, params: { id: another_budget.id }, xhr: true
        end

        it 'has flash error message' do
          expect(flash[:error]).to be
        end

        it 'rescue from Pundit authorize error' do
          should rescue_from(Pundit::NotAuthorizedError).with(:user_not_authorized)
        end
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }
    let(:budget) { create(:budget, user: user) }

    context 'when an unauthenticated user' do
      before(:each) do
        put :update, params: { id: budget.id, budget: { date: Date.current } }
      end

      it 'returns redirect status' do
        expect(response).to have_http_status(:redirect)
      end
      it 'redirect to new user session path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when authenticated user' do
      before(:each) do
        sign_in user
      end

      context 'when send valid params' do
        before(:each) do
          put :update, params: { id: budget.id, budget: { date: (budget.date_from.end_of_month + 1.day).to_s } }
        end
        let!(:budgets_facade) { assigns(:budgets_facade) }

        it 'update budget date' do
          expect(budgets_facade.budget.date_from).to eq budget.date_from.end_of_month + 1.day
        end

        it 'have notice flash message' do
          expect(flash[:notice]).to be_truthy
        end

        it 'updates budget and redirect to budget' do
          expect(response).to redirect_to(budget_path(budgets_facade.budget))
        end
      end

      context 'when send not valid params' do
        before(:each) do
          put :update, params: { id: budget.id, budget: { date: '' } }, xhr: true
        end
        let!(:budgets_facade) { assigns(:budgets_facade) }

        it 'confirms that the budget is not updated' do
          expect(budgets_facade.budget.date_from).to eq budget.date_from
          expect(budgets_facade.budget.date_to).to eq budget.date_to
        end
      end

      context 'when try to update budget that belongs to another user' do
        let(:another_user) { create(:user) }
        let(:another_budget) { create(:budget, user: another_user) }
        before(:each) do
          get :show, params: { id: another_budget.id }, xhr: true
        end

        it 'has flash error message' do
          expect(flash[:error]).to be
        end

        it 'rescue from Pundit authorize error' do
          should rescue_from(Pundit::NotAuthorizedError).with(:user_not_authorized)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    context 'when an unauthenticated user' do
      let(:budget) { create(:budget, user: user) }
      before(:each) do
        delete :destroy, params: { id: budget.id }
      end

      it 'returns redirect status' do
        expect(response).to have_http_status(:redirect)
      end
      it 'redirect to new user session path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when authenticated user' do
      let(:budget) { create(:budget, user: user) }
      before(:each) do
        sign_in user
      end

      context 'when send valid params' do
        before(:each) do
          delete :destroy, params: { id: budget.id }
        end
        let(:budgets_facade) { assigns(:budgets_facade) }

        it 'confirms that the budget delete from database' do
          expect(budgets_facade.budget.persisted?).to be_falsey
        end

        it 'have notice flash message' do
          expect(flash[:notice]).to be_truthy
        end

        it 'destroy budget and redirect to budgets' do
          expect(response).to redirect_to(budgets_path)
        end
      end

      context 'when send not valid params' do
        let(:budget) { create(:budget_with_operations, user: user) }
        before(:each) do
          delete :destroy, params: { id: budget.id }, xhr: true
        end
        let!(:budgets_facade) { assigns(:budgets_facade) }

        it 'confirms that the budget is deleted' do
          expect(budgets_facade.budget.persisted?).to be_truthy
        end

        it 'have error messages in object' do
          expect(budgets_facade.budget.errors).not_to be_empty
        end

        it 'render error messages by js' do
          should render_template(partial: 'partials/_flash')
        end
      end
    end

    context 'when try to delete budget that belongs to another user' do
      let(:another_user) { create(:user) }
      let(:another_budget) { create(:budget, user: another_user) }
      before(:each) do
        sign_in user
        delete :destroy, params: { id: another_budget.id }, xhr: true
      end

      it 'has flash error message' do
        expect(flash[:error]).to be
      end

      it 'render error message by js' do
        expect(response).to render_template(partial: 'partials/_bootstrap_flash')
      end

      it 'rescue from Pundit authorize error' do
        should rescue_from(Pundit::NotAuthorizedError).with(:user_not_authorized)
      end
    end
  end
end
