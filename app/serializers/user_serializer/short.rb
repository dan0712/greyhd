module UserSerializer
  class Short < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :name, :title, :role, :state, :picture,
               :email, :last_activity_at, :start_date, :bio
    has_one :location, serializer: LocationSerializer::Short

    def picture
      if object.profile_image.present?
        object.profile_image.file_url
      else
        ProfileImageUploader.new.default_url
      end
    end

    def name
      object.full_name
    end

    def last_activity_at
      if object.new?
        I18n.t('models.user.last_activity_at.incomplete')
      elsif object.invited?
        I18n.t('models.user.last_activity_at.not_onboarded')
      elsif object.registered? && object.last_sign_in_at.blank?
        I18n.t('models.user.last_activity_at.not_onboarded')
      else
        object.last_sign_in_at.strftime('%d-%b-%Y')
      end
    end
  end
end
