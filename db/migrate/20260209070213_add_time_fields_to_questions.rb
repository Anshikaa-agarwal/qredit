class AddTimeFieldsToQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :questions, :posted_at, :datetime
    add_column :questions, :edited_at, :datetime
  end
end
