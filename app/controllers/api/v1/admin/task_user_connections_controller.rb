module Api
  module V1
    module Admin
      class TaskUserConnectionsController < BaseController
        before_action :authorize_tasks

        load_and_authorize_resource :user

        def assign
          interaction = Interactions::TaskUserConnections::Assign.new(@user,
                                                                      assign_params)
          interaction.perform
          render nothing: true, status: 204
        end

        private

        def assign_params
          params[:tasks] || []
        end

        def authorize_tasks
          Task.where(id: tasks_ids).find_each do |task|
            authorize! :manage, task
          end
        end

        def tasks_ids
          @tasks_ids ||= assign_params.map { |task| task[:id] }
        end
      end
    end
  end
end
