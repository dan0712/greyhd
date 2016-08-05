class Milestone < ActiveRecord::Base
  belongs_to :company
  has_one :milestone_image, as: :entity, class_name: 'UploadedFile::MilestoneImage', dependent: :destroy
end
