# frozen_string_literal: true

class CreateCreators < ActiveRecord::Migration[7.0]
  def change
    create_table :creators do |t|
      t.references :token, null: false, foreign_key: true
      t.text :q1
      t.text :q2
      t.text :q3
      t.boolean :non_profit
      t.text :about
      t.string :location
      t.string :facebook
      t.string :twitter
      t.string :instagram
      t.string :linkedin
      t.string :website
      t.string :discord
      t.string :tag1
      t.string :tag2
      t.string :tag3



      t.timestamps null: false
    end
    # add_index :creators, :confirmation_token,   unique: true
    # add_index :creators, :unlock_token,         unique: true
  end
end
