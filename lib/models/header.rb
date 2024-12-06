require 'dry-struct'
require 'dry-types'

module Types
  include Dry.Types()
end

class Header < Dry::Struct
  attribute :name, Types::String
  attribute :value, Types::String
end