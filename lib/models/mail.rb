require 'dry-struct'
require 'dry-types'
require_relative 'common_headers'
require_relative 'header'

module Types
  include Dry.Types()
end

class Mail < Dry::Struct
  attribute :timestamp, Types::String
  attribute :source, Types::String
  attribute :messageId, Types::String
  attribute :destination, Types::Array.of(Types::String)
  attribute :headersTruncated, Types::Bool
  attribute :headers, Types::Array.of(Header)
  attribute :commonHeaders, CommonHeaders
end