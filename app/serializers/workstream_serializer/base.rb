module WorkstreamSerializer
  class Base < ActiveModel::Serializer
    attributes :id, :name, :tasks_count, :position
  end
end

