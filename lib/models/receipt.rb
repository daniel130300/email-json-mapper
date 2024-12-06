# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'
require_relative 'verdict'
require_relative 'action'

# Custom types module for dry-types integration
module Types
  include Dry.Types()
end

# Represents an AWS SES email receipt containing processing results and authentication verdicts
#
# This class encapsulates the results of various email authentication checks and
# security scans performed by AWS SES when receiving an email.
#
# @example Creating a receipt for a processed email
#   Receipt.new(
#     timestamp: '2024-03-20T10:00:00Z',
#     processingTimeMillis: 100,
#     recipients: ['recipient@example.com'],
#     spamVerdict: Verdict.new(status: 'PASS'),
#     virusVerdict: Verdict.new(status: 'PASS'),
#     spfVerdict: Verdict.new(status: 'PASS'),
#     dkimVerdict: Verdict.new(status: 'PASS'),
#     dmarcVerdict: Verdict.new(status: 'PASS'),
#     dmarcPolicy: 'reject',
#     action: Action.new(type: 'SNS', topicArn: 'arn:aws:sns:...')
#   )
class Receipt < Dry::Struct
  # @!attribute [r] timestamp
  #   @return [String] The ISO8601 timestamp when AWS SES received the email
  attribute :timestamp, Types::String

  # @!attribute [r] processingTimeMillis
  #   @return [Integer] The time in milliseconds that AWS SES spent processing the email
  attribute :processingTimeMillis, Types::Integer

  # @!attribute [r] recipients
  #   @return [Array<String>] The list of recipients from the SMTP RCPT TO command
  attribute :recipients, Types::Array.of(Types::String)

  # @!attribute [r] spamVerdict
  #   @return [Verdict] The verdict from the spam scanning operation
  #   @note AWS SES marks messages as spam based on content scanning
  attribute :spamVerdict, Verdict

  # @!attribute [r] virusVerdict
  #   @return [Verdict] The verdict from the virus scanning operation
  #   @note AWS SES automatically scans all messages for viruses
  attribute :virusVerdict, Verdict

  # @!attribute [r] spfVerdict
  #   @return [Verdict] The verdict from the SPF check
  #   @see https://tools.ietf.org/html/rfc7208 SPF RFC
  attribute :spfVerdict, Verdict

  # @!attribute [r] dkimVerdict
  #   @return [Verdict] The verdict from the DKIM signature verification
  #   @see https://tools.ietf.org/html/rfc6376 DKIM RFC
  attribute :dkimVerdict, Verdict

  # @!attribute [r] dmarcVerdict
  #   @return [Verdict] The verdict from the DMARC check
  #   @see https://tools.ietf.org/html/rfc7489 DMARC RFC
  attribute :dmarcVerdict, Verdict

  # @!attribute [r] dmarcPolicy
  #   @return [String, nil] The DMARC policy (none/quarantine/reject) specified in the sender's DNS
  #   @note This may be nil if no DMARC record was found
  attribute :dmarcPolicy, Types::String.optional

  # @!attribute [r] action
  #   @return [Action] The action taken by AWS SES based on the receipt rules
  attribute :action, Action
end