# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :attachments_facade, only: [:new]

  def new; end

  def create
    if attachments_facade.save!(allowed_params)
      redirect_to attachments_facade.budget, notice: t('.success')
    else
      render_error_messages_by_js(attachment)
    end
  end

  private

  def attachments_facade
    @attachments_facade ||= AttachmentsFacade.new(current_user, params)
  end

  def allowed_params
    params.require(:attachment).permit(:path)
  end
end
