require 'swagger_helper'

RSpec.describe 'api/v1/documents', type: :request do
  describe 'Documents API' do
    path '/api/v1/documents' do
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

          let(:data) do
            {
              data: {
                type: 'documents',
                attributes: {
                  title: 'Sample Document',
                  url: 'http://example.com/sample-document',
                  description: 'A test description for the document.',
                  contributor: 'test@github.com'
                }
              }
            }
          end
          let(:oauth_app) {
            Doorkeeper::Application.create!(
              name: "My Application",
              redirect_uri: "urn:ietf:wg:oauth:2.0:oob"
            )
          }
          let(:access_token)  { Doorkeeper::AccessToken.create!(application: oauth_app) }
          let(:Authorization) { "Bearer #{access_token.token}" }

          response '201', 'succesful' do
            schema '$ref' => '#/components/schemas/document'
            run_test!
          end

          response '422', 'invalid request' do
            let(:data) do
              {
                data: {
                  data: {}
                }
              }
            end
            schema '$ref' => '#/components/schemas/errors_422'
            let(:oauth_app) {
              Doorkeeper::Application.create!(
                name: "My Application",
                redirect_uri: "urn:ietf:wg:oauth:2.0:oob"
              )
            }
            let(:access_token)  { Doorkeeper::AccessToken.create!(application: oauth_app) }
            let(:Authorization) { "Bearer #{access_token.token}" }
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
          security [ bearerAuth: [] ]
          let!(:documents) { FactoryBot.create_list(:document, 3) }
          let(:oauth_app) {
            Doorkeeper::Application.create!(
              name: "My Application",
              redirect_uri: "urn:ietf:wg:oauth:2.0:oob"
            )
          }
          let(:access_token)  { Doorkeeper::AccessToken.create!(application: oauth_app) }
          let(:Authorization) { "Bearer #{access_token.token}" }

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data["data"].size).to eq(3)
          end
        end

        response '404', 'documents not found' do
          schema '$ref' => '#/components/schemas/errors'
          let!(:documents) { [] }
          let(:oauth_app) {
            Doorkeeper::Application.create!(
              name: "My Application",
              redirect_uri: "urn:ietf:wg:oauth:2.0:oob"
            )
          }
          let(:access_token)  { Doorkeeper::AccessToken.create!(application: oauth_app) }
          let(:Authorization) { "Bearer #{access_token.token}" }
          run_test!
        end
      end
    end

    path '/api/v1/documents/{id}' do
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
          schema '$ref' => '#/components/schemas/document'
          let!(:id) { FactoryBot.create(:document).slug }
          let(:oauth_app) {
            Doorkeeper::Application.create!(
              name: "My Application",
              redirect_uri: "urn:ietf:wg:oauth:2.0:oob"
            )
          }
          let(:access_token)  { Doorkeeper::AccessToken.create!(application: oauth_app) }
          let(:Authorization) { "Bearer #{access_token.token}" }

          run_test!
        end

        response '404', 'document not found' do
          schema '$ref' => '#/components/schemas/errors'
          let!(:id) { 'invalid' }
          let(:oauth_app) {
            Doorkeeper::Application.create!(
              name: "My Application",
              redirect_uri: "urn:ietf:wg:oauth:2.0:oob"
            )
          }
          let(:access_token)  { Doorkeeper::AccessToken.create!(application: oauth_app) }
          let(:Authorization) { "Bearer #{access_token.token}" }
          run_test!
        end
      end
    end
  end
end
