module Interactions
  module TaskUserConnections
    class Assign
      def initialize(user, tasks)
        @user = user
        @tasks = tasks
      end

      def perform
        ActiveRecord::Base.transaction do
          @user.task_user_connections.where(task_id: tasks_ids_to_destroy).destroy_all
          @user.task_user_connections.create!(tasks_ids_to_create)
        end
      end

      private

      def tasks_ids_to_create
        @tasks_ids_to_create ||= extract_tasks_ids(:create).map do |id|
          { task_id: id }
        end
      end

      def tasks_ids_to_destroy
        @tasks_ids_to_destroy ||= extract_tasks_ids(:destroy)
      end

      def extract_tasks_ids(action)
        @tasks.map do |task|
          task[:id] if task[:task_user_connection] && task[:task_user_connection][:"_#{action}"]
        end.compact
      end
    end
  end
end
