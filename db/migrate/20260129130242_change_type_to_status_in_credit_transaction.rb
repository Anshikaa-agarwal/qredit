class ChangeTypeToStatusInCreditTransaction < ActiveRecord::Migration[8.1]
  def change
    rename_column :credit_transactions, :type, :status
    # Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
