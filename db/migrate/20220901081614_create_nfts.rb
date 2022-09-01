class CreateNfts < ActiveRecord::Migration[7.0]
  def change
    create_table :nfts do |t|
      t.string :name
      t.references :creator, null: false, foreign_key: true

      t.timestamps
    end
  end
end
