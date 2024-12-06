require 'dry-struct'
require 'dry-types'
require_relative 'verdict'
require_relative 'action'

module Types
  include Dry.Types()
end

class Receipt < Dry::Struct
  attribute :timestamp, Types::String
  attribute :processingTimeMillis, Types::Integer
  attribute :recipients, Types::Array.of(Types::String)
  attribute :spamVerdict, Verdict
  attribute :virusVerdict, Verdict
  attribute :spfVerdict, Verdict
  attribute :dkimVerdict, Verdict
  attribute :dmarcVerdict, Verdict
  attribute :dmarcPolicy, Types::String.optional
  attribute :action, Action
end