class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.string :tk_address
      t.string :nickname
      t.boolean :unlimited
      t.bigint :max_mint
      t.bigint :minted_so_far
      t.float :price
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
