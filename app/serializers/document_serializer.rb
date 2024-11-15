class DocumentSerializer
  include JSONAPI::Serializer
  attributes :title, :url, :description, :contributor
end
