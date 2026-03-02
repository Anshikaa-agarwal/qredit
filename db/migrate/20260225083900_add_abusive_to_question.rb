class AddAbusiveToQuestion < ActiveRecord::Migration[8.1]
  def change
    add_column :questions, :abusive, :boolean, default: false
  end
end
