class CreateSolanaTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :solana_tokens, primary_key: :tk_address do |t|
      t.boolean :unlimited
      t.integer :max_mint
      t.integer :minted_so_far
      t.timestamps
    end
    change_column :solana_tokens, :tk_address, :string
  end
end
