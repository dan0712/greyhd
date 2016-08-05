module Api
  module V1
    module Admin
      class WorkstreamsController < BaseController
        load_and_authorize_resource except: [:connected]

        load_resource :user, only: [:connected]
        authorize_resource only: [:connected]

        def create
          @workstream.save!
          respond_with @workstream, serializer: WorkstreamSerializer::Base
        end

        def show
          respond_with @workstream, serializer: WorkstreamSerializer::Base
        end

        def index
          respond_with @workstreams, each_serializer: WorkstreamSerializer::Base
        end

        def destroy
          @workstream.destroy!
          render nothing: true, status: 204
        end

        def update
          @workstream.update!(workstream_params)
          respond_with @workstream, serializer: WorkstreamSerializer::Base
        end

        def connected
          respond_with current_company.workstreams.includes(tasks: :task_user_connections),
                       user_id: @user.id,
                       include: ['tasks.owner'],
                       each_serializer: WorkstreamSerializer::WithConnections
        end

        private

        def workstream_params
          params.permit(:name, :position)
        end
      end
    end
  end
end
