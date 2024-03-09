class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: {
    admin: 'admin',
    manager: 'manager',
    accounting_clerk: 'accounting_clerk',
    lead: 'lead',
    employee: 'employee',
  }

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  after_commit :produce_create_event, on: :create

  ATTRIBUTES_TO_STREAM = %w[public_id email created_at role full_name position]

  def produce_create_event
    event = {
      event_name: 'AccountCreated',
      data: self.attributes.slice(*ATTRIBUTES_TO_STREAM)
    }
    KAFKA_PRODUCER.produce_sync(topic: 'account-streaming', payload: event.to_json)
  end
end

