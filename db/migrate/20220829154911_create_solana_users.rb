class CreateSolanaUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :solana_users, primary_key: :wlt_address do |t|
      t.string :nickname
      t.timestamps
    end

    change_column :solana_users, :wlt_address, :string
  end
end
