class CreateCreditTransaction < ActiveRecord::Migration[8.1]
  def change
    create_table :credit_transactions do |t|
      t.references :user,   null: false, foreign_key: true
      t.integer    :type,   null: false
      t.bigint     :amount, null: false
      t.string     :reason, null: false

      t.timestamps
    end

    add_check_constraint :credit_transactions, "amount > 0"
  end
end
