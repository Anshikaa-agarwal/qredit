class AddStatusToComments < ActiveRecord::Migration[8.1]
  def change
    add_column :comments, :status, :integer
  end
end
