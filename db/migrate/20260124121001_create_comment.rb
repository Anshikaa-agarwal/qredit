class CreateComment < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.references :user,        null: false, foreign_key: true
      t.references :commentable, null: false, polymorphic: true
      t.string     :content,     null: false

      t.timestamps
    end
  end
end
