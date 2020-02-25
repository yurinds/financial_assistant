# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    context 'when anon get categories' do
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
      let!(:category) { create(:category_income, user: user) }
      let!(:another_category) { create(:category_expense, user: another_user) }

      before(:each) do
        sign_in user
      end

      it 'returns http status success' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'shows only user categories' do
        get :index
        categories_facade = assigns(:categories_facade)

        expect(categories_facade.categories).to eq user.categories
      end
    end
  end

  describe 'GET #new' do
    context 'when authenticated user' do
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
      let(:category) { create(:category_income, user: user) }
      let(:another_user) { create(:user) }
      let(:another_category) { create(:category_expense, user: another_user) }

      before(:each) do
        sign_in user
      end

      context 'when edit users category' do
        it 'returns http success' do
          get :edit, params: { id: category.id }, xhr: true

          expect(response).to have_http_status(:success)
        end
        it 'render form.js.erb' do
          get :edit, params: { id: category.id }, xhr: true

          expect(response).to render_template(:form)
        end
      end
      context 'when edit another users category' do
        it 'has flash error message' do
          get :edit, params: { id: another_category.id }, xhr: true

          expect(flash[:error]).to be
        end
        it 'render partials/bootstrap_flash' do
          get :edit, params: { id: another_category.id }, xhr: true

          expect(response).to render_template('partials/_bootstrap_flash')
        end
      end
    end
  end

  describe 'POST #create' do
    context 'when authenticated user' do
      let(:user) { create(:user) }
      let(:category) { create(:category_income, user: user) }
      let(:another_user) { create(:user) }
      let(:another_category) { create(:category_expense, user: another_user) }

      before(:each) do
        sign_in user
      end

      context 'when create users category' do
        it 'created new category' do
          post :create, params: { category: { name: 'something_category', operation_type: 'income' } }, xhr: true

          expect(response).to have_http_status(:success)
        end
        it 'redirect to categories' do
          post :create, params: { category: { name: 'something_category', operation_type: 'income' } }, xhr: true

          expect(response).to redirect_to(categories_path)
        end
      end

      context 'when send wrong params' do
        it 'has error messages' do
          post :create, params: { category: { 'name' => nil, 'operation_type' => nil } }, xhr: true

          categories_facade = assigns(:categories_facade)

          expect(categories_facade.category.errors[:name]).not_to be_empty
        end
        it 'rendered error partial' do
          post :create, params: { category: { name: '', operation_type: '' } }, xhr: true

          expect(response).to render_template('partials/_flash')
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'when authenticated user' do
      let(:user) { create(:user) }
      let(:category) { create(:category_income, user: user) }
      let(:another_user) { create(:user) }
      let(:another_category) { create(:category_expense, user: another_user) }

      before(:each) do
        sign_in user
      end

      context 'when updated authorized category' do
        it 'updated category' do
          put :update, params: { id: category.id, category: { operation_type: 'expense' } }, xhr: true

          expect(response).to have_http_status(:success)
        end
        it 'redirect to categories' do
          put :update, params: { id: category.id, category: { operation_type: 'expense' } }, xhr: true

          expect(response).to redirect_to(categories_path)
        end
      end

      context 'when send wrong params' do
        it 'has error messages' do
          put :update, params: { id: category.id, category: { name: nil } }, xhr: true

          categories_facade = assigns(:categories_facade)

          expect(categories_facade.category.errors[:name]).not_to be_empty
        end
        it 'rendered error partial' do
          put :update, params: { id: category.id, category: { operation_type: '' } }, xhr: true

          expect(response).to render_template('partials/_flash')
        end
      end
      context 'when updated another users category' do
        it 'has flash error message' do
          put :update, params: { id: another_category.id, category: { name: 'something' } }, xhr: true

          expect(flash[:error]).to be
        end
        it 'render partials/bootstrap_flash' do
          get :edit, params: { id: another_category.id }, xhr: true

          expect(response).to render_template('partials/_bootstrap_flash')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when authenticated user' do
      let(:user) { create(:user) }
      let(:category) { create(:category_income, user: user) }
      let(:another_user) { create(:user) }
      let(:another_category) { create(:category_expense, user: another_user) }

      before(:each) do
        sign_in user
      end

      context 'when destroy authorized category' do
        it 'destroyed category' do
          delete :destroy, params: { id: category.id }, xhr: true

          expect(response).to have_http_status(:success)
        end
        it 'redirect to categories' do
          delete :destroy, params: { id: category.id }, xhr: true

          expect(response).to redirect_to(categories_path)
        end
      end

      context 'when destroy another users category' do
        it 'has flash error message' do
          delete :destroy, params: { id: another_category.id }, xhr: true

          expect(flash[:error]).to be
        end
        it 'render partials/bootstrap_flash' do
          get :edit, params: { id: another_category.id }, xhr: true

          expect(response).to render_template('partials/_bootstrap_flash')
        end
      end
    end
  end
end
