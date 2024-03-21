class Task < ApplicationRecord
  belongs_to :account, optional: true

  def self.find_or_create_with_price(public_id)
    Task.create_with({
                       fee: rand(10..20),
                       price: rand(20..40),
                     }).
      find_or_initialize_by(public_id: public_id)
  end
end
