class CompanyForm < BaseForm
  SINGULAR_RELATIONS = %i(display_logo_image landing_page_image)
  PLURAL_RELATIONS = %i(milestones company_values gallery_images)
  RESERVED_SUBDOMAINS = %w(www)

  attribute :domain, String
  attribute :subdomain, String
  attribute :name, String
  attribute :abbreviation, String
  attribute :brand_color, String
  attribute :email, String
  attribute :bio, String
  attribute :send_email_alerts, Boolean
  attribute :time_zone, String
  attribute :hide_gallery, Boolean
  attribute :company_values, Array[CompanyValueForm]
  attribute :milestones, Array[MilestoneForm]
  attribute :display_logo_image, UploadedFileForm::DisplayLogoImageForm
  attribute :landing_page_image, UploadedFileForm::LandingPageImageForm
  attribute :company_video, String
  attribute :gallery_images, Array[UploadedFileForm::GalleryImageForm]

  validates :name, :subdomain, presence: true
  validates :domain, :subdomain, uniqueness: { model: Company }
  validates :domain, domain: true
  validates :subdomain, subdomain: { reserved: RESERVED_SUBDOMAINS }
  validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.us_zones.map(&:name) }
end
