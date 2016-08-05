module TaskSerializer
  class Base < ActiveModel::Serializer
    attributes :id, :name, :description, :workstream_id, :owner_id, :deadline_in, :position

    has_one :owner, serializer: UserSerializer::Short
    has_many :attachments
  end
end
