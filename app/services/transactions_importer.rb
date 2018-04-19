# frozen_string_literal: true

require 'csv'

class TransactionsImporter
  def initialize(file_name, user, account: nil, type: nil)
    unless ['Credit', 'Debit', 'Savings', nil].include? type
      raise 'Must provide valid account type'
    end
    @file = File.open(file_name)
    @user = user
    @account = account
    @type = type
  end

  def account
    @account ||= find_account
  end

  def transaction_type
    "#{@type}Transaction" unless @type.nil?
  end

  def account_type
    "#{@type}Account" unless @type.nil?
  end

  def import_file_data
    raise 'Cannot determine account' if account.nil?
    file_data do |row|
      Transaction.upsert(
        row.import_data.merge(account_id: account.id, type: transaction_type)
      )
    end
  end

  private

  def file_data
    CSV.foreach(@file, headers: true) do |row|
      yield TransactionRow.new(row)
    end
  end

  def find_account
    return unless account_number.blank?
    Account.find_or_create_by(
      user: @user, account_number: account_number
    )
  end

  def account_number
    @file.path[/(?<=chase)\d{4}/i]
  end
end
