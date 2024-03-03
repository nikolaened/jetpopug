class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  enum role: {
    admin: 'admin',
    accounting_clerk: 'accounting_clerk',
    repairman: 'repairman',
    employee: 'employee'
  }
end

