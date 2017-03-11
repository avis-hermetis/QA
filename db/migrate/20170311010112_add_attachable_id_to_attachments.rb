class AddAttachableIdToAttachments < ActiveRecord::Migration[5.0]
  def change
    add_reference :attachments, :attachable

    add_column :attachments, :attachable_type, :string
    add_index :attachments, :attachable_type
  end
end
