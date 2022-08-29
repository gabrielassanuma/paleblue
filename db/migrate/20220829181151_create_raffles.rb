class CreateRaffles < ActiveRecord::Migration[7.0]
  def change
    create_table :raffles do |t|
      t.text :name
      t.text :about
      t.string :tag1
      t.string :tag2
      t.string :tag3
      t.references :creators, null: false, foreign_key: true
      t.references :solana_tokens, null: false, foreign_key: true

      t.timestamps
    end
  end
end
