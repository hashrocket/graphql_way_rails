class Types::Enum::ProductSort < Types::BaseEnum
  value "nameAsc", value: [:name, :asc]
  value "nameDesc", value: [:name, :desc]
  value "colorAsc", value: [:color, :asc]
  value "colorDesc", value: [:color, :desc]
  value "sizeAsc", value: [:size, :asc]
  value "sizeDesc", value: [:size, :desc]
  value "priceAsc", value: [:price, :asc]
  value "priceDesc", value: [:price, :desc]
end
