require 'swagger_helper'

RSpec.describe 'api/documents', type: :request do
  describe 'Documents API' do
    path '/documents' do
      get 'Retrieves all documents' do
        tags 'Documents'
        produces 'application/json'
        # parameter name: :id, in: :path, type: :string
        # request_body_example value: { some_field: 'Foo' }, name: 'basic', summary: 'Request example description'

        response '200', 'documents found' do
          schema type: :object,
            properties: {
              id: { type: :integer }
              # title: { type: :string },
              # content: { type: :string }
            },
            required: [ 'id' ]
          let(:documents) { create_list(:document, 3) }
          run_test!
        end

        # response '404', 'blog not found' do
        #   let(:id) { 'invalid' }
        #   run_test!
        # end

        # response '406', 'unsupported accept header' do
        #   let(:'Accept') { 'application/foo' }
        #   run_test!
        # end
      end
    end
  end
end
