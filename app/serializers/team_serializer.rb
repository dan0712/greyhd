class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name, :users_count, :owner_id, :description

  has_one :owner, serializer: UserSerializer::Short
  has_many :users, serializer: UserSerializer::Short
end
