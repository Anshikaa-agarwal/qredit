class RemoveEverPublishedFromQuestion < ActiveRecord::Migration[8.1]
  def change
    remove_column :questions, :ever_published
  end
end
