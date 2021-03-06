class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    if current_user&.author_of?(@attachment.attachable)
      @attachment.destroy
    else
      head 403
    end
  end
end
