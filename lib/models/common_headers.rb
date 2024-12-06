require 'dry-struct'
require 'dry-types'

module Types
  include Dry.Types()
end

class CommonHeaders < Dry::Struct
  attribute :returnPath, Types::String
  attribute :from, Types::Array.of(Types::String)
  attribute :date, Types::String
  attribute :to, Types::Array.of(Types::String)
  attribute :messageId, Types::String
  attribute :subject, Types::String
end
