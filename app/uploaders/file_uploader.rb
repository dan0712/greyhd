# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  include Rails.application.routes.url_helpers

  before :cache, :save_original_filename

  def filename
    "#{secure_token}#{File.extname(original_filename).downcase}" if original_filename.present?
  end

  private

  def save_original_filename(file)
    model.original_filename ||= file.original_filename if file.respond_to?(:original_filename)
  end

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(8))
  end
end
