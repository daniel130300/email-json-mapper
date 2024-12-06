# app.rb
require 'sinatra'
require 'json'
require_relative 'models/root'
require_relative 'mappers/json_mapper'

# Define the POST route
post '/map' do
  begin
    # Parse the incoming JSON and convert string keys to symbols
    request_body = JSON.parse(request.body.read, symbolize_names: true)

    # Handle invalid or missing JSON structure
    if request_body.nil? || request_body.empty?
      status 400
      return { error: 'Invalid or empty JSON' }.to_json
    end

    # Initialize the Root model from parsed JSON
    root = Root.new(request_body)

    # Create the JsonMapper instance and map the data
    mapper = JsonMapper.new(root)
    mapped_data = mapper.map

    # Log the mapped data to ensure it's correctly transformed
    puts "Mapped Data: #{mapped_data}"

    # Return the mapped data as a JSON response
    content_type :json
    mapped_data.to_json
  rescue JSON::ParserError => e
    # Handle JSON parsing errors
    status 400
    { error: "Invalid JSON format: #{e.message}" }.to_json
  rescue => e
    # Catch any unexpected errors
    status 500
    { error: "Something went wrong: #{e.message}" }.to_json
  end
end