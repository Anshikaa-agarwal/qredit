class CreateCreditPurchase < ActiveRecord::Migration[8.1]
  def change
    create_table :credit_purchases do |t|
      t.references :user,                  null: false, foreign_key: true
      t.string     :stripe_transaction_id, null: false
      t.integer    :status
      t.bigint     :amount
      t.integer    :unit

      t.timestamps
    end

    add_index :credit_purchases, :stripe_transaction_id, unique: true
  end
end
