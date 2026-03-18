class AddContentToQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :questions, :content, :text, default: ''
  end
end
