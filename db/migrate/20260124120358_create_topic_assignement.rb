class CreateTopicAssignement < ActiveRecord::Migration[8.1]
  def change
    create_table :topic_assignements do |t|
      t.references :topic, null: false, foreign_key: true
      t.references :topicable, polymorphic: true, null: false

      t.timestamps
    end

      add_index :topic_assignements, [:topic_id, :topicable_type, :topicable_id], unique: true
  end
end
