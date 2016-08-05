module UserSerializer
  class Full < Short
    attributes :location_id, :team_id, :manager_id, :personal_email

    has_one :team, serializer: TeamSerializer
    has_one :manager, serializer: UserSerializer::Short
  end
end
