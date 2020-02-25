# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentMethodsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    context 'when anon get payment methods' do
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
      let!(:payment_method) { create(:payment_method, user: user) }
      let!(:another_payment_method) { create(:payment_method, user: another_user) }

      before(:each) do
        sign_in user
      end

      it 'returns http status success' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'shows only user payment methods' do
        get :index
        payment_methods_facade = assigns(:payment_methods_facade)

        expect(payment_methods_facade.payment_methods).to eq user.payment_methods
      end
    end
  end

  describe 'GET #new' do
    context 'when authenticated user create element' do
      let(:user) { create(:user) }

      before(:each) do
        sign_in user
      end

      it 'returns http success' do
        get :new, xhr: true

        expect(response).to have_http_status(:success)
      end
      it 'render form.js.erb' do
        get :new, xhr: true

        expect(response).to render_template(:form)
      end
    end
  end

  describe 'GET #edit' do
    context 'when authenticated user' do
      let(:user) { create(:user) }
      let(:payment_method) { create(:payment_method, user: user) }
      let(:another_user) { create(:user) }
      let(:another_payment_method) { create(:payment_method, user: another_user) }

      before(:each) do
        sign_in user
      end

      context 'when edit users payment method' do
        it 'returns http success' do
          get :edit, params: { id: payment_method.id }, xhr: true

          expect(response).to have_http_status(:success)
        end
        it 'render form.js.erb' do
          get :edit, params: { id: payment_method.id }, xhr: true

          expect(response).to render_template(:form)
        end
      end
      context 'when edit another users payment method' do
        it 'has flash error message' do
          get :edit, params: { id: another_payment_method.id }, xhr: true

          expect(flash[:error]).to be
        end
        it 'render partials/bootstrap_flash' do
          get :edit, params: { id: another_payment_method.id }, xhr: true

          expect(response).to render_template('partials/_bootstrap_flash')
        end
      end
    end
  end

  describe 'POST #create' do
    context 'when authenticated user' do
      let(:user) { create(:user) }
      let(:payment_method) { create(:payment_method, user: user) }
      let(:another_user) { create(:user) }
      let(:another_payment_method) { create(:payment_method, user: another_user) }

      before(:each) do
        sign_in user
      end

      context 'when create users payment method' do
        it 'created new payment method' do
          post :create, params: { payment_method: { name: 'something_new', is_cash: true } }, xhr: true

          expect(response).to have_http_status(:success)
        end
        it 'redirect to payment methods' do
          post :create, params: { payment_method: { name: 'something_new', is_cash: true } }, xhr: true

          expect(response).to redirect_to(payment_methods_path)
        end
      end

      context 'when send wrong params' do
        it 'has error messages' do
          post :create, params: { payment_method: { name: nil } }, xhr: true

          payment_methods_facade = assigns(:payment_methods_facade)

          expect(payment_methods_facade.payment_method.errors[:name]).not_to be_empty
        end
        it 'rendered error partial' do
          post :create, params: { payment_method: { name: '' } }, xhr: true

          expect(response).to render_template('partials/_flash')
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'when authenticated user' do
      let(:user) { create(:user) }
      let(:payment_method) { create(:payment_method, user: user) }
      let(:another_user) { create(:user) }
      let(:another_payment_method) { create(:payment_method, user: another_user) }

      before(:each) do
        sign_in user
      end

      context 'when updated authorized payment method' do
        it 'updated payment method' do
          put :update, params: { id: payment_method.id, payment_method: { is_cash: true } }, xhr: true

          expect(response).to have_http_status(:success)
        end
        it 'redirect to  payment methods' do
          put :update, params: { id: payment_method.id, payment_method: { is_cash: true } }, xhr: true

          expect(response).to redirect_to(payment_methods_path)
        end
      end

      context 'when send wrong params' do
        it 'has error messages' do
          put :update, params: { id: payment_method.id, payment_method: { name: nil } }, xhr: true

          payment_methods_facade = assigns(:payment_methods_facade)

          expect(payment_methods_facade.payment_method.errors[:name]).not_to be_empty
        end
        it 'rendered error partial' do
          put :update, params: { id: payment_method.id, payment_method: { name: nil } }, xhr: true

          expect(response).to render_template('partials/_flash')
        end
      end
      context 'when updated another users payment method' do
        it 'has flash error message' do
          put :update, params: { id: another_payment_method.id, payment_method: { name: 'something' } }, xhr: true

          expect(flash[:error]).to be
        end
        it 'render partials/bootstrap_flash' do
          get :edit, params: { id: another_payment_method.id }, xhr: true

          expect(response).to render_template('partials/_bootstrap_flash')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when authenticated user' do
      let(:user) { create(:user) }
      let(:payment_method) { create(:payment_method, user: user) }
      let(:another_user) { create(:user) }
      let(:another_payment_method) { create(:payment_method, user: another_user) }

      before(:each) do
        sign_in user
      end

      context 'when destroy authorized payment method' do
        it 'destroyed payment method' do
          delete :destroy, params: { id: payment_method.id }, xhr: true

          expect(response).to have_http_status(:success)
        end
        it 'redirect to payment methods' do
          delete :destroy, params: { id: payment_method.id }, xhr: true

          expect(response).to redirect_to(payment_methods_path)
        end
      end

      context 'when destroy another users payment_method' do
        it 'has flash error message' do
          delete :destroy, params: { id: another_payment_method.id }, xhr: true

          expect(flash[:error]).to be
        end
        it 'render partials/bootstrap_flash' do
          get :edit, params: { id: another_payment_method.id }, xhr: true

          expect(response).to render_template('partials/_bootstrap_flash')
        end
      end
    end
  end
end
