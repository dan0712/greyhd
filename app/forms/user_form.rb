class UserForm < BaseForm
  presents :user

  attribute :first_name, String
  attribute :last_name, String
  attribute :email, String
  attribute :personal_email, String
  attribute :title, String
  attribute :start_date, Date
  attribute :location_id, Integer
  attribute :manager_id, Integer
  attribute :team_id, Integer
  attribute :company_id, Integer
  attribute :profile_image, UploadedFileForm::ProfileImageForm

  validates :company_id, :email, :title, :first_name, :last_name, :start_date, presence: true
  validates :email, :personal_email, email: true, uniqueness: { scope: :company_id, case_sensitive: false, model: User }
  validates_date :start_date, on_or_after: :today, if: :start_date_changed?
end
