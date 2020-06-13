# frozen_string_literal: true

class AttachmentsFacade
  attr_reader :params, :user

  def initialize(user, params)
    @params = params
    @user = user
  end

  def budget
    @budget ||= Budget.find(params[:budget_id])
  end

  def attachment
    params[:id] ? set_attachment : new_attachment
  end

  def new_attachment(allowed_params = {})
    @new_attachment ||= budget.attachments.build(allowed_params)
  end

  def save!(allowed_params = {})
    Operation.transaction do
      new_attachment(allowed_params).save!

      operations = MegafonOperationXlsxParser.new(path: file_path, user: user).parse
      OperationsCreator.new(operations: operations, budget: budget).perform
    end
  end

  private

  def file_path
    new_attachment.path.url
  end

  def set_attachment
    @attachment ||= Attachment.find(params[:id])
  end
end
