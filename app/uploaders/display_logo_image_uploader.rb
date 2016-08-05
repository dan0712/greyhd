# encoding: utf-8

class DisplayLogoImageUploader < ImageUploader
  def default_url(*args)
    ActionController::Base.helpers.asset_path('fallback/' + [version_name, 'default_display_logo_image.svg'].compact.join('_'))
  end
end
