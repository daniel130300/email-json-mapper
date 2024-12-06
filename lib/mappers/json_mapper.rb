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
    transform(@root)
  end

  private

  def transform(root)
    transform_keys(root) do |key|
      key.to_s.underscore.to_sym
    end
  end

  def transform_keys(value, &block)
    case value
    when Hash
      Hash[value.map { |k, v| [block.call(k), transform_keys(v, &block)] }]
    when Array
      value.map { |item| transform_keys(item, &block) }
    else
      value
    end
  end

  def verdict_status(verdict)
    verdict.status == 'PASS'
  end

  def dns_status
    ses_receipt = @root.Records.first.ses.receipt
    [ses_receipt.spfVerdict, ses_receipt.dkimVerdict, ses_receipt.dmarcVerdict].all? { |verdict| verdict.status == 'PASS' }
  end

  def retrasado_status
    @root.Records.first.ses.receipt.processingTimeMillis > 1000
  end
end