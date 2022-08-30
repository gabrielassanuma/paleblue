class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :wlt_address
      t.string :nickname
      t.timestamps
    end
  end
end
