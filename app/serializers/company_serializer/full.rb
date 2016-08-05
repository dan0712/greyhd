module CompanySerializer
  class Full < ActiveModel::Serializer
    attributes :id, :name, :abbreviation, :email, :bio, :time_zone,
               :brand_color, :send_email_alerts, :company_video,
               :users_count, :teams_count, :locations_count, :logo
    has_many :milestones
    has_many :company_values
    has_one :display_logo_image
    has_one :landing_page_image
    has_many :gallery_images

    def logo
      if object.display_logo_image.present?
        object.display_logo_image.file_url
      else
        DisplayLogoImageUploader.new.default_url
      end
    end
  end
end
