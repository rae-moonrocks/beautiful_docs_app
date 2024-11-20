class DocumentSerializer
  include JSONAPI::Serializer
  set_id :slug
  attributes :title, :url, :description, :contributor, :created_at, :updated_at
end
