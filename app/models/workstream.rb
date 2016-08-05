class Workstream < ActiveRecord::Base
  belongs_to :company

  has_many :tasks, dependent: :destroy

  validates :company, :name, presence: true

  acts_as_list scope: :company

  default_scope { order(position: :asc) }
end
