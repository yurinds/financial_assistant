# frozen_string_literal: true

class Attachment < ApplicationRecord
  belongs_to :budget

  mount_uploader :path, AttachmentUploader

  private
end
