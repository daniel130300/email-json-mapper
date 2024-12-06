require 'dry-struct'
require 'dry-types'
require_relative 'ses'

module Types
  include Dry.Types()
end

class Record < Dry::Struct
  attribute :eventVersion, Types::String
  attribute :ses, SES
  attribute :eventSource, Types::String
end