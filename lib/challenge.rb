require 'sinatra'
require 'json'
require 'mailparser'
require 'open-uri'
require 'base64'

# Endpoint to parse email and return only the attached JSON
post '/parse-email' do
  content_type :json
  email_file = params[:email_file]

  # Check if the email is from a URL or local file path
  if email_file.start_with?('http://', 'https://')
    begin
      # Open and read the email content from URL
      email_content = URI.open(email_file).read
    rescue => e
      status 500
      return { error: "Error fetching email from URL: #{e.message}" }.to_json
    end
  else
    # Ensure the email file exists if it's a local file
    unless File.exist?(email_file)
      status 400
      return { error: 'Email file not found' }.to_json
    end

    begin
      # Read the email content from a local file
      email_content = File.read(email_file)
    rescue => e
      status 500
      return { error: "Error reading the file: #{e.message}" }.to_json
    end
  end

  begin
    puts "email_content #{email_content}"
    email = MailParser::Message.new(email_content, output_charset: 'utf-8')
    
    # Case 1: Check attachments
    email_parts = email.part
    email_parts.each do |part|
      begin
        json_content = JSON.parse(part.body)
        return json_content.to_json
      rescue JSON::ParserError
        next
      end
    end
    
    # Case 2: Check for direct URLs in email body
    urls = email.body.scan(/https?:\/\/[^\s<>"]+/)
    urls.each do |url|
      begin
        content = URI.open(url, read_timeout: 10).read
        # Try parsing the content directly as JSON
        json_content = JSON.parse(content)
        return json_content.to_json
      rescue JSON::ParserError
        # Case 3: If not JSON, check if it's HTML containing JSON links
        if content.match?(/html/i)
          nested_urls = content.scan(/https?:\/\/[^\s<>"]+\.json/)
          nested_urls.each do |nested_url|
            begin
              nested_content = URI.open(nested_url, read_timeout: 10).read
              json_content = JSON.parse(nested_content)
              return json_content.to_json
            rescue
              next
            end
          end
        end
      rescue
        next
      end
    end
    
    # If no JSON found in parts or URLs, try parsing the main body
    begin
      json_content = JSON.parse(email.body)
      return json_content.to_json
    rescue JSON::ParserError
      status 400
      return { error: 'No valid JSON content found in email or linked resources' }.to_json
    end

  rescue => e
    # Handle errors during email parsing
    status 500
    return { error: "Something went wrong: #{e.message}" }.to_json
  end
end