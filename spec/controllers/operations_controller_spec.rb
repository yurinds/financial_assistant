# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OperationsController, type: :controller do
  describe 'GET #new' do
    let(:user) { create(:user) }
    let(:budget) { create(:budget, user: user) }

    context 'when an unauthenticated user' do
      before(:each) do
        get :new, params: { budget_id: budget.id }, xhr: true
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when authenticated user' do
      before(:each) do
        sign_in user
        get :new, params: { budget_id: budget.id }, xhr: true
      end

      it { should render_template('new') }
      it 'returns http status success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }
    let(:budget) { create(:budget, user: user) }
    let(:operation) { create(:operation_with_income, budget: budget) }

    context 'when an unauthenticated user' do
      before(:each) do
        get :edit, params: { budget_id: budget.id, id: operation.id }, xhr: true
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when authenticated user' do
      before(:each) do
        sign_in user
      end

      context 'when edit budget operation that belongs to user' do
        before(:each) do
          get :edit, params: { budget_id: budget.id, id: operation.id }, xhr: true
        end
        let(:operations_facade) { assigns(:operations_facade) }

        it 'have http status success' do
          expect(response).to have_http_status(:success)
        end

        it 'edit current operation' do
          expect(operations_facade.operation).to eq operation
        end

        it 'render edit template' do
          should render_template(:new)
        end
      end

      context 'when edit budget operation that belongs to another user' do
        let(:another_user) { create(:user) }
        let(:another_budget) { create(:budget, user: another_user) }
        let(:another_operation) { create(:operation_with_income, budget: another_budget) }
        before(:each) do
          get :edit, params: { budget_id: another_budget.id, id: another_operation.id }, xhr: true
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

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:budget) { create(:budget, user: user) }
    let(:category) { create(:category_income, user: user) }
    let(:payment_method) { create(:payment_method, user: user) }
    let(:operation) { create(:operation_with_income, budget: budget) }
    let(:correct_operation_params) do
      {
        date: budget.date_from,
        description: 'something',
        category_id: category.id,
        payment_method_id: payment_method.id,
        amount: '5000'
      }
    end
    let(:wrong_operation_params) do
      {
        date: '',
        description: '',
        category_id: '',
        payment_method_id: '',
        amount: ''
      }
    end

    context 'when an unauthenticated user' do
      before(:each) do
        post :create, params: { budget_id: budget.id, operation: correct_operation_params }
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
          post :create, params: { budget_id: budget.id, operation: correct_operation_params }
        end
        let!(:operations_facade) { assigns(:operations_facade) }

        it 'confirms that the operation is in the database' do
          expect(operations_facade.new_operation.persisted?).to be_truthy
        end

        it 'have notice flash message' do
          expect(flash[:notice]).to be_truthy
        end

        it 'creates new budget operation and redirect to budget' do
          expect(response).to redirect_to(budget_path(budget))
        end
      end

      context 'when send not valid params' do
        before(:each) do
          post :create, params: { budget_id: budget.id, operation: wrong_operation_params }, xhr: true
        end
        let!(:operations_facade) { assigns(:operations_facade) }

        it 'confirms that the budget is not created' do
          expect(operations_facade.new_operation.persisted?).to be_falsey
        end

        it 'have error messages in object' do
          expect(operations_facade.new_operation.errors).not_to be_empty
        end

        it 'render error messages by js' do
          should render_template(partial: 'partials/_flash')
        end
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }
    let(:budget) { create(:budget, user: user) }
    let(:category) { create(:category_income, user: user) }
    let(:payment_method) { create(:payment_method, user: user) }
    let(:operation) { create(:operation_with_income, budget: budget) }
    let(:correct_operation_params) do
      {
        date: budget.date_from,
        description: 'something',
        category_id: category.id,
        payment_method_id: payment_method.id,
        amount: '5000'
      }
    end
    let(:wrong_operation_params) do
      {
        date: '',
        description: '',
        category_id: '',
        payment_method_id: '',
        amount: ''
      }
    end

    context 'when an unauthenticated user' do
      before(:each) do
        put :update, params: { budget_id: budget.id, id: operation.id, operation: wrong_operation_params }
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
          put :update, params: { budget_id: budget.id, id: operation.id, operation: correct_operation_params }
        end
        let!(:operations_facade) { assigns(:operations_facade) }

        it 'update operation' do
          expect(operations_facade.operation.category).to eq category
        end

        it 'have notice flash message' do
          expect(flash[:notice]).to be_truthy
        end

        it 'updates operation and redirect to budget' do
          expect(response).to redirect_to(budget_path(budget))
        end
      end

      context 'when send not valid params' do
        before(:each) do
          put :update, params: { budget_id: budget.id, id: operation.id, operation: wrong_operation_params }, xhr: true
        end
        let!(:operations_facade) { assigns(:operations_facade) }

        it 'confirms that the operation is not updated' do
          expect(operations_facade.operation.category).not_to eq category
        end

        it 'have error messages' do
          expect(operations_facade.operation.errors.full_messages).to be
        end

        it 'render error messages by js' do
          expect(response).to render_template(partial: 'partials/_flash')
        end
      end

      context 'when try to update budget that belongs to another user' do
        let(:another_user) { create(:user) }
        let(:another_budget) { create(:budget, user: another_user) }
        let(:another_operation) { create(:operation_with_income, budget: another_budget) }
        before(:each) do
          put :update, params: { budget_id: another_budget.id, id: another_operation.id, operation: correct_operation_params }, xhr: true
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
    let(:budget) { create(:budget, user: user) }
    let(:operation) { create(:operation_with_income, budget: budget) }

    context 'when an unauthenticated user' do
      before(:each) do
        delete :destroy, params: { budget_id: budget.id, id: operation.id }
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
          delete :destroy, params: { budget_id: budget.id, id: operation.id }
        end
        let!(:operations_facade) { assigns(:operations_facade) }

        it 'confirms that the operation delete from database' do
          expect(operations_facade.operation.persisted?).to be_falsey
        end

        it 'have notice flash message' do
          expect(flash[:notice]).to be_truthy
        end

        it 'destroy operation and redirect to budgets' do
          expect(response).to redirect_to(budget_path(budget))
        end
      end
    end

    context 'when try to delete operation that belongs to another user' do
      let(:another_user) { create(:user) }
      let(:another_budget) { create(:budget, user: another_user) }
      let(:another_operation) { create(:operation_with_income, budget: another_budget) }
      before(:each) do
        sign_in user
        delete :destroy, params: { budget_id: another_budget.id, id: another_operation.id }, xhr: true
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
