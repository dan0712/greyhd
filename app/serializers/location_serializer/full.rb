class LocationSerializer::Full < LocationSerializer::Short
  has_one :owner, serializer: UserSerializer::Short
  has_many :users, serializer: UserSerializer::Short
end
