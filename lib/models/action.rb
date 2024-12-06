# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'

# Custom types module for dry-types integration
module Types
  include Dry.Types()
end

# Represents an action that can be performed in the system
#
# @example Creating a new action
#   Action.new(
#     type: 'notification',
#     topicArn: 'arn:aws:sns:region:account:topic'
#   )
class Action < Dry::Struct
  # @!attribute [r] type
  #   @return [String] The type of action to be performed
  attribute :type, Types::String

  # @!attribute [r] topicArn
  #   @return [String] The Amazon SNS topic ARN where the action will be published
  attribute :topicArn, Types::String
end