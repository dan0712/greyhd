module WorkstreamSerializer
  class WithConnections < Base
    has_many :tasks, serializer: TaskSerializer::WithConnections
  end
end

