class AddTransactionReferenceToPayment < ActiveRecord::Migration[7.1]
  def change
     add_reference :payments, :transaction, index: true
  end
end
