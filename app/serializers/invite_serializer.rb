class InviteSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :welcome_note, :additional_information
end
