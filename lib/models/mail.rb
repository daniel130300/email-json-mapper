# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'
require_relative 'common_headers'
require_relative 'header'

# Custom types module for dry-types integration
module Types
  include Dry.Types()
end

# Represents an email message with its metadata and headers
#
# @example Creating a new mail object
#   Mail.new(
#     timestamp: '2024-03-20T10:00:00Z',
#     source: 'sender@example.com',
#     messageId: '<123456@example.com>',
#     destination: ['recipient@example.com'],
#     headersTruncated: false,
#     headers: [
#       Header.new(name: 'Content-Type', value: 'text/plain')
#     ],
#     commonHeaders: CommonHeaders.new(...)
#   )
class Mail < Dry::Struct
  # @!attribute [r] timestamp
  #   @return [String] The ISO8601 timestamp when the message was received
  attribute :timestamp, Types::String

  # @!attribute [r] source
  #   @return [String] The sender's email address
  attribute :source, Types::String

  # @!attribute [r] messageId
  #   @return [String] The unique identifier for the email message
  attribute :messageId, Types::String

  # @!attribute [r] destination
  #   @return [Array<String>] List of recipient email addresses
  attribute :destination, Types::Array.of(Types::String)

  # @!attribute [r] headersTruncated
  #   @return [Boolean] Indicates if the headers were truncated due to size limitations
  attribute :headersTruncated, Types::Bool

  # @!attribute [r] headers
  #   @return [Array<Header>] List of all email headers
  attribute :headers, Types::Array.of(Header)

  # @!attribute [r] commonHeaders
  #   @return [CommonHeaders] Commonly used email headers in a structured format
  attribute :commonHeaders, CommonHeaders
end