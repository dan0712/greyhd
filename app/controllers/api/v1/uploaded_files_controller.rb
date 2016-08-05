module Api
  module V1
    class UploadedFilesController < ApiController
      FILE_TYPES = {
        'display_logo_image' => 'UploadedFile::DisplayLogoImage',
        'landing_page_image' => 'UploadedFile::LandingPageImage',
        'profile_image' => 'UploadedFile::ProfileImage',
        'gallery_image' => 'UploadedFile::GalleryImage',
        'milestone_image' => 'UploadedFile::MilestoneImage',
        'attachment' => 'UploadedFile::Attachment'
      }
      before_action :require_company!
      before_action :authenticate_user!
      before_action :verify_current_user_in_current_company!
      load_and_authorize_resource

      def create
        @uploaded_file.save!
        respond_with @uploaded_file
      end

      def update
        @uploaded_file.update(uploaded_file_params)
        respond_with @uploaded_file
      end

      def clear
        @uploaded_file.clear_file
        respond_with @uploaded_file
      end

      def destroy
        respond_with @uploaded_file
      end

      private

      def uploaded_file_params
        type = FILE_TYPES[params[:type]]
        raise ActiveRecord::RecordNotFound if type.nil?

        params.permit(
          :file, :entity_id, :entity_type, :remove_file
        ).merge(company_id: current_company.id).merge(type: type)
      end
    end
  end
end
