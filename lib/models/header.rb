# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'

# Custom types module for dry-types integration
module Types
  include Dry.Types()
end

# Represents a generic key-value header
#
# @example Creating a new header
#   Header.new(
#     name: 'Content-Type',
#     value: 'text/plain'
#   )
class Header < Dry::Struct
  # @!attribute [r] name
  #   @return [String] The name/key of the header
  attribute :name, Types::String

  # @!attribute [r] value
  #   @return [String] The value associated with the header
  attribute :value, Types::String
end