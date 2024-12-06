# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'
require_relative 'record'

# Custom types module for dry-types integration
module Types
  include Dry.Types()
end

# Represents the root structure of an AWS SES event notification
#
# This class serves as the entry point for parsing AWS SES notifications,
# typically received through AWS Lambda or SNS. It contains an array of
# individual email processing records.
#
# @example Creating a root object from SES events
#   Root.new(
#     Records: [
#       Record.new(
#         eventVersion: '1.0',
#         eventSource: 'aws:ses',
#         ses: SES.new(...)
#       )
#     ]
#   )
class Root < Dry::Struct
  # @!attribute [r] Records
  #   @return [Array<Record>] Array of SES event records
  #   @note The attribute name is capitalized to match AWS's JSON structure
  attribute :Records, Types::Array.of(Record)
end