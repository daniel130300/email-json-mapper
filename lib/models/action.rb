require 'dry-struct'
require 'dry-types'

module Types
  include Dry.Types()
end

class Action < Dry::Struct
  attribute :type, Types::String
  attribute :topicArn, Types::String
end