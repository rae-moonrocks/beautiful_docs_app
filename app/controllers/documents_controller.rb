class DocumentsController < ApplicationController
  before_action :set_document, only: [ :show, :edit ]
  # skip_before_action :verify_authenticity_token

  def index
    @documents = Document.order(created_at: :desc).limit(5)
  end

  def new
    @document = Document.new
  end

  def show
  end

  def create
    command = document_creator
    @document = command[:record]
    if command[:success]
      respond_to do |format|
        format.turbo_stream
        # format.html { redirect_to messages_url }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("modal_content", partial: "documents/form", locals: { document: @document }) }
      end
    end
  end

  def edit
  end

  def update
  end

  private
  attr_accessor :document_creator_result

  def set_document
    @document ||= Document.friendly.find(document_params[:id], allow_nil: true)
  end

  def create_document_params
    params.require(:document).permit(:title, :description, :url, :contributor, :contributor_type)
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
      document = Document.create(create_document_params)
      result = { record: document }
      if document.valid?
        result[:success] = true
      else
        result[:success] = false
      end
      result
    end
  end
end
