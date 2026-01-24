class CreateAbuse < ActiveRecord::Migration[8.1]
  def change
    create_table :abuses do |t|
      t.references :reported_by, null: false, foreign_key: { to_table: :users }
      t.references :reportable,  null: false, polymorphic: true
      t.string     :reason,      null: false

      t.timestamps
    end
  end
end
