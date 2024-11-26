require 'swagger_helper'

RSpec.describe 'api/documents', type: :request do
  describe 'Documents API' do
    path '/documents' do
      post 'Creates a document' do
        example_title  = Faker::Lorem.sentence
        tags 'Documents'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :data, in: :body, schema: {
          type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                type: { type: :string, enum: [ 'documents' ], example: 'documents' },
                attributes: {
                  type: :object,
                  properties: {
                    title: { type: :string, example: example_title },
                    url: { type: :string, format: :uri, example: "http://examples.com/#{example_title.parameterize}" },
                    description: { type: :string, example: "A document illustrating the technicalities of #{example_title}" },
                    contributor: { type: :string, example: 'username@github.com' }
                  }
                }
              }
            }
          }
        }
        after do |example|
          content = example.metadata[:response][:content] || {}
          example_spec = {
            "application/json"=>{
              examples: {
                test_example: {
                  value: JSON.parse(response.body, symbolize_names: true)
                }
              }
            }
          }
          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end

        response '201', 'succesful' do
          schema '$ref' => '#/components/schemas/documents'
          run_test!
        end

        response '422', 'invalid request' do
          schema '$ref' => '#/components/schemas/errors_422'
          run_test!
        end
      end
      get 'Lists all documents' do
        tags 'Documents'
        produces 'application/json'
        after do |example|
          content = example.metadata[:response][:content] || {}
          example_spec = {
            "application/json"=>{
              examples: {
                test_example: {
                  value: JSON.parse(response.body, symbolize_names: true)
                }
              }
            }
          }
          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end
        response '200', 'succesful' do
          schema '$ref' => '#/components/schemas/documents'
          let!(:documents) { FactoryBot.create_list(:document, 3) }



          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["data"].size).to eq(3)
          end
        end

        response '404', 'documents not found' do
          schema '$ref' => '#/components/schemas/errors'
          let!(:documents) { [] }
          run_test!
        end
      end
    end

    path '/documents/{id}' do
      get 'Retrieves a document' do
        tags 'Documents'
        parameter name: :id, in: :path, type: :string
        produces 'application/json'
        after do |example|
          content = example.metadata[:response][:content] || {}
          example_spec = {
            "application/json"=>{
              examples: {
                test_example: {
                  value: JSON.parse(response.body, symbolize_names: true)
                }
              }
            }
          }
          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end

        response '200', 'succesful' do
          schema '$ref' => '#/components/schemas/documents'
          let!(:id) { FactoryBot.create(:document).slug }



          run_test! do |response|
            # data = JSON.parse(response.body)
            # expect(data["data"].size).to eq(3)
          end
        end

        response '404', 'document not found' do
          schema '$ref' => '#/components/schemas/errors'
          let!(:id) { 'invalid' }
          run_test!
        end
      end
    end
  end
end
