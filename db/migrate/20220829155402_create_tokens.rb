class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.string :tk_address
      t.string :nickname
      t.boolean :unlimited, default: false
      t.bigint :max_mint, default: 1
      t.bigint :minted_so_far, default: 0
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
