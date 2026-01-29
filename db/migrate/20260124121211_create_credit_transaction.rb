class CreateCreditTransaction < ActiveRecord::Migration[8.1]
  def change
    create_table :credit_transactions do |t|
      t.references :user,   null: false, foreign_key: true
      t.bigint     :units,  null: false
      t.integer    :type,   null: false       # earnt/spend
      t.references :source, polymorphic: true # question/answer/purchase
      t.string     :reason                    # optional reason

      t.timestamps
    end

    add_check_constraint :credit_transactions, "units > 0"
  end
end
