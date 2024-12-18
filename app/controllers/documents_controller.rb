class DocumentsController < ApplicationController
  before_action :set_document, only: [ :show ]
  skip_before_action :verify_authenticity_token

  def index
    @documents = Document.all
  end

  def show
  end

  def create
  end

  private
  attr_accessor :document_creator_result

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
