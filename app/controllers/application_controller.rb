# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}", scope: 'pundit', default: :default

    respond_to do |format|
      format.html { redirect_to(request.referrer || root_path) }
      format.js { render partial: 'partials/bootstrap_flash' }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: %i[username email password password_confirmation current_password]
    )
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[username email password password_confirmation])
  end
end
