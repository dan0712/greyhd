module Api
  module V1
    module Admin
      class TasksController < BaseController
        load_and_authorize_resource :workstream
        load_and_authorize_resource :task, through: :workstream, shallow: true

        before_action :authorize_attachments, only: [:create, :update]

        def create
          @task.save!
          respond_with @task, serializer: TaskSerializer::Base
        end

        def show
          respond_with @task, serializer: TaskSerializer::Base
        end

        def index
          respond_with @tasks, each_serializer: TaskSerializer::Base
        end

        def update
          @task.update!(task_params)
          respond_with @task, serializer: TaskSerializer::Base
        end

        def destroy
          @task.destroy!
          render nothing: true, status: 204
        end

        private

        def task_params
          params.permit(:name, :description, :deadline_in, :owner_id, :position)
                .merge(attachment_ids: attachment_ids)
        end

        def attachment_ids
          @attachment_ids ||= (params[:attachments] || []).map do |attachment|
            attachment[:id]
          end
        end

        def authorize_attachments
          UploadedFile::Attachment.where(id: attachment_ids).find_each do |attachment|
            authorize! :manage, attachment
          end
        end
      end
    end
  end
end
