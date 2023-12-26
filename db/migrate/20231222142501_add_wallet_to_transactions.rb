class AddWalletToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_reference :transactions, :wallet, null: false, foreign_key: true
  end
end
