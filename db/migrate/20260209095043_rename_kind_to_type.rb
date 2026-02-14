class RenameKindToType < ActiveRecord::Migration[8.1]
  def change
    rename_column :votes, :kind, :type
    # Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
