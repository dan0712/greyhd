class UploadedFile < ActiveRecord::Base
  belongs_to :entity, polymorphic: true
  scope :expired, -> { where(entity_id: nil).where('updated_at < ?', 1.day.ago) }

  def clear_file
    self.remove_file!
    save
  end

  class ProfileImage < self
    mount_uploader :file, ProfileImageUploader
  end

  class MilestoneImage < self
    mount_uploader :file, ImageUploader
  end

  class DisplayLogoImage < self
    mount_uploader :file, DisplayLogoImageUploader
  end

  class LandingPageImage < self
    mount_uploader :file, ImageUploader
  end

  class GalleryImage < self
    mount_uploader :file, ImageUploader
  end

  class Attachment < self
    mount_uploader :file, FileUploader
  end
end
