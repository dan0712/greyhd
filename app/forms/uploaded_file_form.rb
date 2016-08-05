class UploadedFileForm < BaseForm
  attribute :type, String
  attribute :file, Object
  attribute :entity_id, Integer
  attribute :entity_type, String

  delegate :file_url, to: :record

  class ProfileImageForm < self
    attribute :remove_file, Boolean
    attribute :type, String, default: 'UploadedFile::ProfileImage'
  end

  class MilestoneImageForm < self
    attribute :type, String, default: 'UploadedFile::MilestoneImage'
    validates :file, presence: true
    attribute :remove_file, Boolean
  end

  class DisplayLogoImageForm < self
    attribute :type, String, default: 'UploadedFile::DisplayLogoImage'
    attribute :remove_file, Boolean
  end

  class LandingPageImageForm < self
    attribute :type, String, default: 'UploadedFile::LandingPageImage'
    attribute :remove_file, Boolean
  end

  class GalleryImageForm < self
    attribute :type, String, default: 'UploadedFile::GalleryImage'
    validates :file, presence: true
  end
end
