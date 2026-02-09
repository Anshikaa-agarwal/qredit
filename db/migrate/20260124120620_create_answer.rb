class CreateAnswer < ActiveRecord::Migration[8.1]
  def change
    create_table :answers do |t|
      t.references :user,     null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.string :content,      null: false
      t.integer :status,      null: false, default: 0

      t.timestamps
    end

    add_index :answers, [ :user_id, :question_id ], unique: true
  end
end
