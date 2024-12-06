# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'

# Custom types module for dry-types integration
module Types
  include Dry.Types()
end

# Represents the common email headers in a message
#
# @example Creating new common headers
#   CommonHeaders.new(
#     returnPath: 'sender@example.com',
#     from: ['sender@example.com'],
#     date: '2024-03-20T10:00:00Z',
#     to: ['recipient@example.com'],
#     messageId: '<123456@example.com>',
#     subject: 'Hello World'
#   )
class CommonHeaders < Dry::Struct
  # @!attribute [r] returnPath
  #   @return [String] The email address for bounce messages
  attribute :returnPath, Types::String

  # @!attribute [r] from
  #   @return [Array<String>] List of sender email addresses
  attribute :from, Types::Array.of(Types::String)

  # @!attribute [r] date
  #   @return [String] The date and time when the message was sent
  attribute :date, Types::String

  # @!attribute [r] to
  #   @return [Array<String>] List of recipient email addresses
  attribute :to, Types::Array.of(Types::String)

  # @!attribute [r] messageId
  #   @return [String] The unique identifier for the email message
  attribute :messageId, Types::String

  # @!attribute [r] subject
  #   @return [String] The subject line of the email
  attribute :subject, Types::String
end