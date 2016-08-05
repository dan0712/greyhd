# encoding: utf-8

class ImageUploader < FileUploader
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
