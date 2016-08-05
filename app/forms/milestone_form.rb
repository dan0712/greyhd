class MilestoneForm < BaseForm
  SINGULAR_RELATIONS = %i(milestone_image)

  attribute :happened_at, Date
  attribute :name, String
  attribute :description, String
  attribute :milestone_image, UploadedFileForm::MilestoneImageForm

  validates :name, :happened_at, :milestone_image, :description, presence: true
end
