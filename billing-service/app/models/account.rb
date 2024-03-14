class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :transactions
  has_many :payments
  has_many :tasks
  has_one :balance

  enum role: {
    admin: 'admin',
    manager: 'manager',
    accounting_clerk: 'accounting_clerk',
    lead: 'lead',
    employee: 'employee',
  }

  scope :enabled, -> { where(active: true) }

  ALLOWED_UPDATE_ATTRIBUTES = %w[full_name email position role]

  def name
    full_name.presence || "email: #{email}"
  end
end
