require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:file) {create(:attachment, attachable: question)}

  describe 'DELETE #destroy' do

    context 'Authenticated user is the author of attachable object' do
      before {sign_in user}

      it 'assigns requested attachment form the db to the @attachmebt variable' do
        patch :destroy, params: {id: file, format: :js}
        expect(assigns(:attachment)).to eq file
      end
      it 'deletes an attachment' do
        expect {patch :destroy, params: {id: file, format: :js}}.to change(Attachment, :count).by(-1)
      end
      it 'renders destroy template' do
        patch :destroy, params: {id: file, format: :js}
        expect(response).to render_template :destroy
      end
    end

    context 'Authenticated user is NOT author of attachable object' do
      before {sign_in other_user}

      it 'failes to delete an attachment' do
        expect { patch :destroy, params: {id: file, format: :js} }.to_not change(Attachment, :count)
      end
      it 'renders status 403 without destroy template' do
        patch :destroy, params: {id: file, format: :js}
        expect(response).to_not render_template :destroy
        expect(response).to have_http_status(403)
      end
    end

    context 'NOT authenticated user' do

      it 'failes to delete an attachment' do
        expect {patch :destroy, params: {id: file, format: :js}}.to_not change(Attachment, :count)
      end
      it 'renders status 403 without destroy template' do
        patch :destroy, params: {id: file, format: :js}
        expect(response).to_not render_template :destroy
        expect(response).to have_http_status(401)
      end
    end

  end
end
