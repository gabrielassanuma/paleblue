class CreateTokenBalances < ActiveRecord::Migration[7.0]
  def change
    create_table :token_balances do |t|
      t.bigint :amount_tokens
      t.references :solana_users, null: false, foreign_key: true
      t.references :solana_tokens, null: false, foreign_key: true

      t.timestamps
    end
  end
end
