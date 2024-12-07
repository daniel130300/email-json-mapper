# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'mailparser'
require 'open-uri'
require 'base64'

# Email JSON Extraction Service
#
# This Sinatra application provides an endpoint for extracting JSON content from emails.
# It can process emails from either a URL or local file path and attempts to find JSON
# content in multiple locations within the email:
# 1. Email attachments
# 2. URLs within the email body
# 3. Nested JSON URLs in HTML content
# 4. The email body itself
#
# @example Sending a request
#   POST /parse-email?email_file=https://example.com/email.eml
#   POST /parse-email?email_file=/path/to/local/email.eml
#
# @see https://github.com/mailparser/mailparser-ruby MailParser documentation

# Extracts JSON content from an email file
#
# @param [String] params[:email_file] URL or file path to the email
# @return [String] Extracted JSON content
# @status 200 Successfully extracted JSON
# @status 400 Email file not found or no valid JSON content
# @status 500 Server error during processing
post '/parse-email' do
  content_type :json
  email_file = params[:email_file]

  # Phase 1: Email Content Retrieval
  # Determine source and fetch email content accordingly
  if email_file.start_with?('http://', 'https://')
    begin
      # Fetch email content from remote URL with default timeout
      email_content = URI.open(email_file).read
    rescue => e
      status 500
      return { error: "Error fetching email from URL: #{e.message}" }.to_json
    end
  else
    # Handle local file access
    unless File.exist?(email_file)
      status 400
      return { error: 'Email file not found' }.to_json
    end

    begin
      email_content = File.read(email_file)
    rescue => e
      status 500
      return { error: "Error reading the file: #{e.message}" }.to_json
    end
  end

  begin    
    # Parse email with UTF-8 encoding to handle international characters
    email = MailParser::Message.new(email_content, output_charset: 'utf-8')
    
    # Phase 2: JSON Extraction Strategy 1 - Check Attachments
    # Iterate through email parts looking for JSON attachments
    email_parts = email.part
    email_parts.each do |part|
      begin
        json_content = JSON.parse(part.body)
        return json_content.to_json
      rescue JSON::ParserError
        next # Continue to next part if this one isn't valid JSON
      end
    end
    
    # Phase 3: JSON Extraction Strategy 2 - Check URLs in Email Body
    # Find and check all URLs in the email body
    urls = email.body.scan(/https?:\/\/[^\s<>"]+/)
    urls.each do |url|
      begin
        # Fetch content from URL with 10-second timeout
        content = URI.open(url, read_timeout: 10).read
        
        # Try parsing the content as JSON directly
        json_content = JSON.parse(content)
        return json_content.to_json
      rescue JSON::ParserError
        # Phase 4: JSON Extraction Strategy 3 - Check for Nested JSON URLs
        # If content is HTML, look for .json URLs within it
        if content.match?(/html/i)
          nested_urls = content.scan(/https?:\/\/[^\s<>"]+/)
          nested_urls.each do |nested_url|
            begin
              nested_content = URI.open(nested_url, read_timeout: 10).read
              json_content = JSON.parse(nested_content)
              return json_content.to_json
            rescue
              next # Continue to next nested URL if this one fails
            end
          end
        end
      rescue
        next # Continue to next URL if this one fails
      end
    end
  rescue => e
    # Handle any unexpected errors during the entire process
    status 500
    return { error: "Something went wrong: #{e.message}" }.to_json
  end
end