module TaskSerializer
  class WithConnections < Base
    attributes :task_user_connection

    def task_user_connection
      object.task_user_connections.find_by(user_id: instance_options[:user_id])
    end
  end
end
