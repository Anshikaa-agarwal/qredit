class AddEverPublishedToQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :questions, :ever_published, :boolean, default: false, null: false
  end
end
