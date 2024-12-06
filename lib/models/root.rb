require 'dry-struct'
require 'dry-types'
require_relative 'record'

module Types
  include Dry.Types()
end

class Root < Dry::Struct
  attribute :Records, Types::Array.of(Record)
end