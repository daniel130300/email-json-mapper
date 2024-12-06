require 'dry-struct'
require 'dry-types'
require_relative 'mail'
require_relative 'receipt'

module Types
  include Dry.Types()
end

class SES < Dry::Struct
  attribute :mail, Mail
  attribute :receipt, Receipt
end