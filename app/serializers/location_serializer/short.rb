class LocationSerializer::Short < ActiveModel::Serializer
  attributes :id, :name, :users_count, :owner_id, :description
end
