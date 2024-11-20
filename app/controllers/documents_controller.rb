class DocumentsController < ApplicationController
  before_action :set_document, only: [ :show ]
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

  def show
    if @document
      render json: DocumentSerializer.new(@document).serializable_hash.to_json
    else
      render json: {
        "errors": [
          {
            "status": 404,
            "source": { "pointer": "/documents/#{document_params[:id]}" },
            "detail": "Document not found"
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

  def set_document
    @document ||= Document.friendly.find(document_params[:id])
  end

  def document_params
    params.permit(:id)
  end
end
