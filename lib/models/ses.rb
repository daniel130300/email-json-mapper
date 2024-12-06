# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'
require_relative 'mail'
require_relative 'receipt'

# Custom types module for dry-types integration
module Types
  include Dry.Types()
end

# Represents the core AWS SES event data structure
#
# This class combines the email message details and its processing receipt,
# providing a complete view of an email event in AWS SES.
#
# @example Creating an SES event object
#   SES.new(
#     mail: Mail.new(
#       timestamp: '2024-03-20T10:00:00Z',
#       source: 'sender@example.com',
#       messageId: '<123456@example.com>',
#       destination: ['recipient@example.com'],
#       headersTruncated: false,
#       headers: [],
#       commonHeaders: CommonHeaders.new(...)
#     ),
#     receipt: Receipt.new(
#       timestamp: '2024-03-20T10:00:00Z',
#       processingTimeMillis: 100,
#       recipients: ['recipient@example.com'],
#       spamVerdict: Verdict.new(...),
#       virusVerdict: Verdict.new(...),
#       spfVerdict: Verdict.new(...),
#       dkimVerdict: Verdict.new(...),
#       dmarcVerdict: Verdict.new(...),
#       action: Action.new(...)
#     )
#   )
class SES < Dry::Struct
  # @!attribute [r] mail
  #   @return [Mail] The email message details including headers and routing information
  attribute :mail, Mail

  # @!attribute [r] receipt
  #   @return [Receipt] The processing results and security verdicts for the email
  attribute :receipt, Receipt
end