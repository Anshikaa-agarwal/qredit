class AddAbusiveToComment < ActiveRecord::Migration[8.1]
  def change
    add_column :comments, :abusive, :boolean, default: false
  end
end
