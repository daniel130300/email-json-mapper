# frozen_string_literal: true

require 'sinatra'
require 'json'
require_relative 'models/root'
require_relative 'mappers/json_mapper'

# AWS SES Event Mapping Service
#
# This Sinatra application provides an endpoint for processing AWS SES event
# notifications and transforming them into a different JSON structure.
#
# @example Sending a request
#   POST /map
#   Content-Type: application/json
#   
#   {
#     "Records": [{
#       "eventVersion": "1.0",
#       "eventSource": "aws:ses",
#       "ses": {
#         "mail": { ... },
#         "receipt": { ... }
#       }
#     }]
#   }
#
# @see models/root.rb for the complete input structure
# @see mappers/json_mapper.rb for the transformation logic

# Maps AWS SES event notifications to a custom JSON format
#
# @param [String] request.body Raw JSON payload from AWS SES
# @return [String] Transformed JSON response
# @status 200 Successfully mapped the input
# @status 400 Invalid JSON or missing required fields
# @status 500 Internal server error
post '/map' do
  begin
    # Parse the incoming JSON and convert string keys to symbols
    # This is necessary because our Dry::Struct models expect symbol keys
    request_body = JSON.parse(request.body.read, symbolize_names: true)

    # Validate that we received a non-empty JSON structure
    # Return early with an error if the payload is invalid
    if request_body.nil? || request_body.empty?
      status 400
      return { error: 'Invalid or empty JSON' }.to_json
    end

    # Initialize our domain model from the parsed JSON
    # This will validate the structure against our Dry::Struct definitions
    root = Root.new(request_body)

    # Transform the data using our custom mapper
    # The mapper converts our domain model to the desired output format
    mapper = JsonMapper.new(root)
    mapped_data = mapper.map

    # Set response type and return the transformed data
    content_type :json
    mapped_data.to_json

  rescue Dry::Struct::Error => e
    # Handle validation errors from Dry::Struct
    # Extract the missing field name from the error message if possible
    field_missing = e.message.match(/:([a-zA-Z0-9_]+)/)&.captures&.first
    
    status 400
    if field_missing
      { 
        error: "Missing required field: '#{field_missing}'. Please make sure your JSON is complete and correct." 
      }.to_json
    else
      { 
        error: "Missing required field in the JSON input." 
      }.to_json
    end

  rescue => e
    # Catch any unexpected errors and return a 500 response
    # Include the error message to help with debugging
    status 500
    { 
      error: "Something went wrong: #{e.message}" 
    }.to_json
  end
end