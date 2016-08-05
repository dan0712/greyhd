class User < ActiveRecord::Base
  devise :database_authenticatable, :trackable,
         authentication_keys: [:email, :personal_email]

  include DeviseTokenAuth::Concerns::User

  belongs_to :company, counter_cache: true
  belongs_to :team, counter_cache: true
  belongs_to :location, counter_cache: true
  belongs_to :manager, class_name: 'User'

  has_many :managed_users, class_name: 'User', foreign_key: :manager_id, dependent: :nullify
  has_many :teams, foreign_key: :owner_id, dependent: :nullify
  has_many :locations, foreign_key: :owner_id, dependent: :nullify

  has_many :invites, dependent: :destroy
  has_many :task_user_connections, dependent: :destroy
  has_one :profile_image, as: :entity, dependent: :destroy,
                          class_name: 'UploadedFile::ProfileImage'
  has_one :owned_company, foreign_key: :owner_id, class_name: 'Company'

  enum role: { employee: 0, admin: 1, account_owner: 2 }

  state_machine :state, initial: :new do
    event :invite do
      transition new: :invited
    end

    event :register do
      transition invited: :registered
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
