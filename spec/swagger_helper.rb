# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        description: 'The Beautiful Docs API V1 is a REST interface designed to transform the [Beautiful Docs repository](https://github.com/matheusfelipeog/beautiful-docs) into a structured and accessible API. This API provides access to the documentation resources curated by [matheusfelipeog](https://github.com/matheusfelipeog) and other developers. Built to enhance the usability of the original repository, this API simplifies the process of integrating and exploring high-quality documentation by offering endpoints tailored for easy access and interaction.',
        termsOfService: "#{ENV.fetch('SERVER_URL')}/terms",
        contact: { email: 'rachel@moonrocks.dev' },
        title: 'Beautiful Docs API V1',
        version: 'v1'
      },
      security: [
        bearerAuth: []
      ],
      paths: {},
      servers: [
        {
          url: ENV.fetch('SERVER_URL'),
          variables: {
            defaultHost: {
              default: ENV.fetch('HOST')
            }
          }
        }
      ],
      tags: [
        {
          name: 'Documents',
          description: 'All the beautiful docs in one place',
          externalDocs: {
              description: 'Original source',
              url: 'https://github.com/matheusfelipeog/beautiful-docs'
          }
        }
      ],
      components: {
        schemas: {
          document: {
            type: 'object',
            properties: {
              data: {
                type: 'object',
                properties: {
                  id: { type: 'string', example: '99' },
                  type: { type: 'string', example: 'documents' },
                  attributes: {
                    type: 'object',
                    properties: {
                      title: { type: 'string', example: 'The Ruby Style Guide' },
                      url: { type: 'string', example: 'www.examples.com/ruby-style-guide' },
                      description: { type: 'string', example: 'A community-driven Ruby coding style guide' },
                      contributor: { type: 'string', example: 'username@github.com' }
                    },
                    required: [ 'url' ]
                  }
                }
              }
            }
          },
          documents: {
            type: 'object',
            properties: {
              data: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    id: { type: 'string', example: '99' },
                    type: { type: 'string', example: 'documents' },
                    attributes: {
                      type: 'object',
                      properties: {
                        title: { type: 'string', example: 'The Ruby Style Guide' },
                        url: { type: 'string', example: 'www.examples.com/ruby-style-guide' },
                        description: { type: 'string', example: 'A community-driven Ruby coding style guide' },
                        contributor: { type: 'string', example: 'username@github.com' }
                      },
                      required: [ 'url' ]
                    }
                  }
                }
              }
            }
          },
          errors: {
            type: 'object',
            properties: {
              errors: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    source: {
                      type: 'object',
                      properties: {
                        pointer: { type: 'string', example: '/documents/99' }
                      }
                    },
                    detail: { type: 'string', example: 'Document not found' },
                    status: { type: 'integer', example: 404 }
                  }
                }
              }
            }
          },
          errors_422: {
            type: 'object',
            properties: {
              errors: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    source: {
                      type: 'object',
                      properties: {
                        pointer: { type: 'string', example: '/documents' }
                      }
                    },
                    detail: { type: 'string', example: 'Invalid Request' },
                    status: { type: 'integer', example: 422 }
                  }
                }
              }
            }
          }
        },
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
