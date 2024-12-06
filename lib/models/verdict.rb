# frozen_string_literal: true

require 'dry-struct'
require 'dry-types'

# Custom types module for dry-types integration
module Types
  include Dry.Types()
end

# Represents an AWS SES verification verdict
#
# This class encapsulates the result of various email verification checks
# performed by AWS SES, such as spam detection, virus scanning, and
# email authentication (SPF, DKIM, DMARC).
#
# @example Creating a verdict
#   Verdict.new(status: 'PASS')
#
# @example Common status values
#   - 'PASS'     # The check was successful
#   - 'FAIL'     # The check failed
#   - 'GRAY'     # The check produced an indeterminate result
#   - 'PROCESSING_FAILED' # The check could not be completed
#   - 'DISABLED' # The check was disabled by configuration
class Verdict < Dry::Struct
  # @!attribute [r] status
  #   @return [String] The result of the verification check
  #   @example "PASS", "FAIL", "GRAY", "PROCESSING_FAILED", "DISABLED"
  attribute :status, Types::String
end