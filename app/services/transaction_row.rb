# frozen_strin_literal: true

class TransactionRow
  HEADER_MAP = {
    'Trans Date' => 'transaction_date',
    'Post Date' => 'posting_date',
    'Type' => 'transaction_type'
  }.freeze
  def initialize(row)
    @data = row.to_hash
  end

  def import_data
    sanitized_data.symbolize_keys
  end

  private

  def sanitized_data
    transformed_data.select do |key, val|
      valid_cols.include?(key) && val.present?
    end
  end

  def transformed_data
    squished_values.transform_keys! do |key|
      HEADER_MAP[key] || key.downcase.tr(' ', '_')
    end
  end

  def squished_values
    cleaned_data.transform_values!(&:squish)
  end

  def cleaned_data
    @data.reject { |key, val| key.nil? || val.nil? }
  end

  def valid_cols
    @valid_cols ||= Transaction.column_names
  end
end
