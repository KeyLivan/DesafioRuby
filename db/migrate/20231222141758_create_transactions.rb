class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :type
      t.decimal :value

      t.timestamps
    end
  end
end
