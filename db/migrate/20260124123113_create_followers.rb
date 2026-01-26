class CreateFollowers < ActiveRecord::Migration[8.1]
  def change
    create_table :followers do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followee, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :followers, [ :follower_id, :followee_id ], unique: true
    add_check_constraint :followers, "follower_id <> followee_id"
  end
end
