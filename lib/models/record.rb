# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'
require_relative 'ses'

# Custom types module for dry-types integration
module Types
  include Dry.Types()
end

# Represents an AWS SES event record
#
# This class represents a record from AWS SES events, containing information
# about email processing events and their metadata.
#
# @example Creating a new record
#   Record.new(
#     eventVersion: '1.0',
#     eventSource: 'aws:ses',
#     ses: SES.new(...)
#   )
class Record < Dry::Struct
  # @!attribute [r] eventVersion
  #   @return [String] The version of the event format
  #   @example "1.0"
  attribute :eventVersion, Types::String

  # @!attribute [r] ses
  #   @return [SES] The SES event data containing mail and receipt information
  attribute :ses, SES

  # @!attribute [r] eventSource
  #   @return [String] The AWS service that generated the event
  #   @example "aws:ses"
  attribute :eventSource, Types::String
end