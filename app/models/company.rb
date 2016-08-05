class Company < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  with_options dependent: :destroy do
    has_many :users
    has_many :teams
    has_many :locations
    has_many :company_values
    has_many :milestones
    has_many :workstreams
    with_options as: :entity do |record|
      record.has_one :display_logo_image, class_name: 'UploadedFile::DisplayLogoImage'
      record.has_one :landing_page_image, class_name: 'UploadedFile::LandingPageImage'
      record.has_many :gallery_images, class_name: 'UploadedFile::GalleryImage'
    end
  end

  def email_address
    "#{email}@greyhd.com" if email.present?
  end
end
