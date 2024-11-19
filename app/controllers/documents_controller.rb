class DocumentsController < ApplicationController
  def index
    @documents = Document.all

    if @documents.any?
      render json: serialized_resources
    else
        render json: {
            "errors": [
              {
                "status": 404,
                "source": { "pointer": "/documents" },
                "detail": "No documents found"
              }
            ]
          }.to_json, status: :not_found
    end
  end

  private

  def serialized_resources
    options = {}
    options[:is_collection] = true
    DocumentSerializer.new(@documents, options).serializable_hash.to_json
  end
end
