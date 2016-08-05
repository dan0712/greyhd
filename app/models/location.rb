class Location < ActiveRecord::Base
  belongs_to :company, counter_cache: true
  belongs_to :owner, class_name: 'User'

  has_many :users, dependent: :nullify

  validates :name, :company, presence: true
end
