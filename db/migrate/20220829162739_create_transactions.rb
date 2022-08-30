class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.bigint :tk_amount
      t.references :from_user, foreign_key: { to_table: :users }
      t.references :to_user, foreign_key: { to_table: :users }
      t.references :token, foreign_key: true, null: false
    end
  end
end
