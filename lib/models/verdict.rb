require 'dry-struct'
require 'dry-types'

module Types
  include Dry.Types()
end

class Verdict < Dry::Struct
  attribute :status, Types::String
end