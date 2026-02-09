class AddTimeFieldsToQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :questions, :posted_at, :time
    add_column :questions, :edited_at, :time
  end
end
