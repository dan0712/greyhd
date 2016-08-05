class MilestoneSerializer < ActiveModel::Serializer
  attributes :id, :name, :happened_at, :description
  has_one :milestone_image
end
