class AddAbusiveToAnswer < ActiveRecord::Migration[8.1]
  def change
    add_column :answers, :abusive, :boolean, default: false
  end
end
