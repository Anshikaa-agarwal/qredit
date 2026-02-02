class AddAuthTokenToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :auth_token, :string
  end
end
