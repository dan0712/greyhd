# encoding: utf-8

class ProfileImageUploader < ImageUploader
  def default_url(*args)
    ActionController::Base.helpers.asset_path('fallback/' + [version_name, 'default_profile_image.png'].compact.join('_'))
  end
end
