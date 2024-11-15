class DocumentsController < ApplicationController
  def index
    @documents = Document.all
    render json: serialized_resources
  end

  private

  def serialized_resources
    options = {}
    options[:is_collection] = true
    DocumentSerializer.new(@documents, options).serializable_hash.to_json
  end
end
