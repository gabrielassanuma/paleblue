class CreateSolanaTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :solana_transactions do |t|
      t.bigint :value
      t.string :from_user, foreign_key: { to_table: :solana_users }
      t.string :to_user, foreign_key: { to_table: :solana_users }
      t.references :solana_token, foreign_key: true, null: false
    end
  end
end
