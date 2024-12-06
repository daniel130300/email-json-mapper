require 'dry-struct'
require 'dry-types'

module Types
  include Dry.Types()
end

class JsonMapper
  def initialize(root)
    @root = root
  end

  def map
    # Map the root data to the requested structure
    {
      spam: verdict_status(@root.Records.first.ses.receipt.spamVerdict),
      virus: verdict_status(@root.Records.first.ses.receipt.virusVerdict),
      dns: dns_status,
      mes: extract_month(@root.Records.first.ses.mail.timestamp),
      retrasado: retrasado_status,
      emisor: extract_email_username(@root.Records.first.ses.mail.source),
      receptor: extract_email_usernames(@root.Records.first.ses.mail.destination)
    }
  end

  private

  # Check if verdict status is 'PASS'
  def verdict_status(verdict)
    verdict.status == 'PASS'
  end

  # Check if spfVerdict, dkimVerdict, and dmarcVerdict are all 'PASS'
  def dns_status
    ses_receipt = @root.Records.first.ses.receipt
    [ses_receipt.spfVerdict, ses_receipt.dkimVerdict, ses_receipt.dmarcVerdict].all? { |verdict| verdict.status == 'PASS' }
  end

  # Extract the month from the timestamp in text format (e.g., "September")
  def extract_month(timestamp)
    # Parse the timestamp and extract the month name
    Date.parse(timestamp).strftime('%B')
  end

  # Check if processingTimeMillis > 1000
  def retrasado_status
    @root.Records.first.ses.receipt.processingTimeMillis > 1000
  end

  # Extract the email username (part before @domain.com)
  def extract_email_username(email)
    email.split('@').first
  end

  # Extract the email usernames from the destination array (part before @domain.com)
  def extract_email_usernames(emails)
    emails.map { |email| email.split('@').first }
  end
end
