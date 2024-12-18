class DocumentsController < ApplicationController
  before_action :set_document, only: [ :show ]
  skip_before_action :verify_authenticity_token

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

  def create
    if document_creator[:success]
      render json: DocumentSerializer.new(document_creator_result[:record]).serializable_hash.to_json, status: :created
    else
      render json: {
        "errors": [
          {
            "status": 422,
            "source": { "pointer": "/documents" },
            "detail": document_creator_result[:error].message
          }
        ]
      }.to_json, status: :unprocessable_entity
    end
  end

  private
  attr_accessor :document_creator_result

  def serialized_resources
    options = {}
    options[:is_collection] = true
    DocumentSerializer.new(@documents, options).serializable_hash.to_json
  end

  def set_document
    @document ||= Document.friendly.find(document_params[:id], allow_nil: true)
  end

  def create_document_params
    params.require(:data).permit(:type, { attributes: [ :url, :title, :description, :contributor ] })
  end

  def document_params
    params.permit(:id)
  end

  # this would not live here, but in a service object
  # adding here for simplicity
  def document_creator
    # sanitize params
    # check if url is valid
    # parse contributor for contributor_type
    @document_creator_result ||= begin
      { success: true, record: Document.create(create_document_params[:attributes]) }
    rescue ActiveRecord::RecordNotUnique => e
      { success: false, error: e }
    end
  end
end
