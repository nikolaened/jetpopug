class Task < ApplicationRecord
  belongs_to :account, optional: true
end
