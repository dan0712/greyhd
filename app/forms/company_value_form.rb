class CompanyValueForm < BaseForm
  attribute :name, String
  attribute :description, String

  validates :name, :description, presence: true
end
